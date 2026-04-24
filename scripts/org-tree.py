#!/usr/bin/env python3
"""
Build org tree under Tavi Siochi using Graph $batch BFS.
One HTTP call per tree level (up to 20 directReports lookups per batch).
~4 round-trips for the whole subtree instead of 350 pages of all users.
"""

import json
import subprocess
import sys
import time

import requests

ROOT_ID = "b8f37439-6ebb-42fc-956c-5c64c51f4e2b"
GRAPH_BASE = "https://graph.microsoft.com/v1.0"
BATCH_URL = "https://graph.microsoft.com/v1.0/$batch"
BATCH_LIMIT = 20

NON_HUMAN_TITLES = {"Generic", "Service Account-Mailbox", "Service Account"}


def is_human(entry):
    odata_type = entry.get("@odata.type", "")
    if odata_type and odata_type != "#microsoft.graph.user":
        return False
    title = entry.get("jobTitle") or ""
    for marker in NON_HUMAN_TITLES:
        if marker in title:
            return False
    return True


def get_token():
    result = subprocess.run(
        ["az", "account", "get-access-token",
         "--resource", "https://graph.microsoft.com",
         "--query", "accessToken", "-o", "tsv"],
        capture_output=True, text=True,
    )
    if result.returncode != 0:
        print(f"Failed to get token: {result.stderr}", file=sys.stderr)
        sys.exit(1)
    return result.stdout.strip()


def graph_get(token, url):
    headers = {"Authorization": f"Bearer {token}"}
    r = requests.get(url, headers=headers, timeout=30)
    r.raise_for_status()
    return r.json()


def batch_direct_reports(token, parent_ids):
    """Fetch directReports for a list of parent IDs using $batch.
    Returns {parent_id: [child_dicts]}."""
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }
    result = {}
    # Split into chunks of BATCH_LIMIT
    chunks = [parent_ids[i:i + BATCH_LIMIT] for i in range(0, len(parent_ids), BATCH_LIMIT)]
    for chunk in chunks:
        batch_body = {
            "requests": [
                {
                    "id": pid,
                    "method": "GET",
                    "url": f"/users/{pid}/directReports?$select=id,displayName,jobTitle",
                }
                for pid in chunk
            ]
        }
        for attempt in range(5):
            try:
                r = requests.post(BATCH_URL, headers=headers,
                                  json=batch_body, timeout=60)
                if r.status_code == 429:
                    wait = int(r.headers.get("Retry-After", 10))
                    print(f"  Throttled, waiting {wait}s...", file=sys.stderr)
                    time.sleep(wait)
                    continue
                r.raise_for_status()
                break
            except (requests.ConnectionError, requests.Timeout):
                time.sleep(2 ** attempt)
        else:
            print("  Batch failed after retries", file=sys.stderr)
            continue

        for resp in r.json().get("responses", []):
            pid = resp["id"]
            if resp.get("status") == 200:
                result[pid] = resp["body"].get("value", [])
            else:
                result[pid] = []
    return result


def main():
    token = get_token()

    # Get root user info
    root = graph_get(token, f"{GRAPH_BASE}/users/{ROOT_ID}?$select=id,displayName,jobTitle")
    user_map = {ROOT_ID: {"name": root["displayName"], "title": root.get("jobTitle", "")}}
    children = {}

    # BFS: level by level using $batch
    frontier = [ROOT_ID]
    level = 0
    total_fetched = 0

    while frontier:
        level += 1
        print(f"  Level {level}: fetching directReports for {len(frontier)} nodes...", file=sys.stderr)
        reports = batch_direct_reports(token, frontier)
        next_frontier = []
        for pid, kids in reports.items():
            children[pid] = []
            for kid in kids:
                if not is_human(kid):
                    continue
                kid_id = kid["id"]
                user_map[kid_id] = {
                    "name": kid.get("displayName", ""),
                    "title": kid.get("jobTitle", ""),
                }
                children[pid].append(kid_id)
                next_frontier.append(kid_id)
                total_fetched += 1
        frontier = next_frontier

    print(f"  Done: {total_fetched} reports found in {level} levels\n", file=sys.stderr)

    # Print tree
    def count(nid):
        total = 0
        for cid in children.get(nid, []):
            total += 1 + count(cid)
        return total

    def show(nid, prefix="", is_last=True):
        node = user_map.get(nid)
        if not node:
            return
        conn = "`-- " if is_last else "|-- "
        title = f" ({node['title']})" if node["title"] else ""
        n = count(nid)
        ns = f" [{n}]" if n > 0 else ""
        print(f"{prefix}{conn}{node['name']}{title}{ns}")
        kids = sorted(children.get(nid, []),
                      key=lambda c: user_map.get(c, {}).get("name", ""))
        npfx = prefix + ("    " if is_last else "|   ")
        for i, kid in enumerate(kids):
            show(kid, npfx, i == len(kids) - 1)

    total = count(ROOT_ID)
    print(f"Org tree under {user_map[ROOT_ID]['name']} ({total} reports):\n")
    show(ROOT_ID)


if __name__ == "__main__":
    main()
