import http.server
import socketserver
import os
import sys

PORT = 8080
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DIRECTORY = os.path.join(BASE_DIR, "build", "web")

class SPANoCacheHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def end_headers(self):
        # Force browser to never cache during development
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        self.send_header('Access-Control-Allow-Origin', '*')
        super().end_headers()

    def do_GET(self):
        # If requested path does not exist as file, serve index.html for SPA routing
        path = self.translate_path(self.path)
        if not os.path.exists(path) and not os.path.splitext(self.path)[1]:
            self.path = '/index.html'
        return super().do_GET()

if __name__ == '__main__':
    # Allow socket reuse immediately on restart
    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("", PORT), SPANoCacheHandler) as httpd:
        print(f"Karigaar Flutter Web Server running at http://localhost:{PORT}")
        sys.stdout.flush()
        httpd.serve_forever()
