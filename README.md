# RPM-Builder
RPM-Builder is a simple tool to generate .rpm files for use with Docker.

# Usage

Generate CA, client and server certificates and keys (replace `registry.example.com` with your registry endpoint)
` docker run --rm -v /tmp/rpm:/build rpm-builder registry.example.com`

Generate client and server certificates and keys using an existing CA (replace `registry.example.com` with your registry endpoint)
` docker run --rm -v /tmp/rpm:/build -v /path/to/certs:/certs rpm-builder registry.example.com --tls-ca-cert=/certs/ca.pem --tls-ca-key=/certs/ca-key.pem`

this is currently a work in progress.
