#!/usr/bin/env python3

import json
import socket
from datetime import datetime
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        parsed_path = urlparse(self.path)

        if parsed_path.path == '/':
            # Get client IP address
            client_ip = self.get_client_ip()

            # Get current timestamp
            timestamp = datetime.now().isoformat()

            # Create JSON response
            response_data = {
                "timestamp": timestamp,
                "ip": client_ip
            }

            # Send response
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps(response_data).encode('utf-8'))
        else:
            # Return 404 for other paths
            self.send_response(404)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            error_response = {"error": "Not found"}
            self.wfile.write(json.dumps(error_response).encode('utf-8'))

    def get_client_ip(self):
        # Try to get the real client IP from headers (in case of proxy/load balancer)
        forwarded_for = self.headers.get('X-Forwarded-For')
        if forwarded_for:
            # X-Forwarded-For can contain multiple IPs, take the first one
            return forwarded_for.split(',')[0].strip()

        real_ip = self.headers.get('X-Real-IP')
        if real_ip:
            return real_ip

        # Fall back to direct client address
        return self.client_address[0]

    def log_message(self, format, *args):
        # Suppress default logging
        pass

def run_server(host='0.0.0.0', port=8005):
    server_address = (host, port)
    httpd = HTTPServer(server_address, RequestHandler)
    print(f"Server running on http://{host}:{port}")
    httpd.serve_forever()

if __name__ == '__main__':
    run_server()