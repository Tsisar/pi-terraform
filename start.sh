#!/bin/bash

# Set the file name for the credentials
credentials="credentials.txt"
# Set the username for the service
username="admin"
# Generate a random password for Prometheus
password=$(openssl rand -base64 10)

# Create or update the .auth file for Prometheus with the new password
echo "$username:$(openssl passwd -apr1 "$password")" > .auth/prometheus

# Write the service name, username, and password to psw.txt for the user
{
    echo "Service: Prometheus"
    echo "Username: $username"
    echo "Password: $password"
} > $credentials

# Generate a random password for Jaeger
password=$(openssl rand -base64 10)

# Create or update the .auth file for Jaeger with the new password
echo "$username:$(openssl passwd -apr1 "$password")" > .auth/jaeger

# Write the service name, username, and password to psw.txt for the user
{
  echo ""
  echo "Jaeger"
  echo "Username: $username"
  echo "Password: $password"
} >> $credentials


echo "Credentials generated for Prometheus web interface."
echo "Login and password are stored in $credentials."
