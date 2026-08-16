#!/usr/bin/env python3
"""离线静态服务：以 http.server 提供 site/ 目录。

必须经此方式浏览（或 python -m http.server -d site），
禁止双击 index.html —— file:// 协议下搜索功能被浏览器 CORS 拦截。

用法：
    python tools/serve.py [--port 8000] [--host 127.0.0.1] [--open]
"""
import argparse
import functools
import http.server
import webbrowser
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
SITE_DIR = PROJECT_ROOT / "site"


def main():
    ap = argparse.ArgumentParser(description="Serve built site offline")
    ap.add_argument("--port", type=int, default=8000)
    ap.add_argument("--host", default="127.0.0.1")
    ap.add_argument("--open", action="store_true", help="open browser")
    args = ap.parse_args()

    if not (SITE_DIR / "index.html").exists():
        print("ERROR: site/ not built yet. Run: python tools/check.py")
        return 2

    handler = functools.partial(
        http.server.SimpleHTTPRequestHandler, directory=str(SITE_DIR)
    )
    url = "http://%s:%d/" % (args.host, args.port)
    print("Serving %s at %s  (Ctrl+C to stop)" % (SITE_DIR, url))
    if args.open:
        webbrowser.open(url)
    try:
        http.server.ThreadingHTTPServer((args.host, args.port), handler).serve_forever()
    except KeyboardInterrupt:
        print("\nStopped.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
