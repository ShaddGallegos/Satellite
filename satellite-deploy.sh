#!/bin/bash

# Red Hat Satellite 6.17 Integrated Deployment Launcher
# This is a simple launcher for the integrated Ansible deployment system

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_header() { echo -e "${CYAN}=== $1 ===${NC}"; }

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Display banner
echo ""
echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║         🛰️  RED HAT SATELLITE 6.17 INTEGRATED LAUNCHER            ║"
echo "╠════════════════════════════════════════════════════════════════════╣"
echo "║                                                                    ║"
echo "║  This launcher provides access to the integrated Satellite        ║"
echo "║  deployment system with all functionality built into the          ║"
echo "║  main Ansible playbook.                                           ║"
echo "║                                                                    ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

# Check prerequisites
print_header "Checking Prerequisites"

# Check if ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    print_error "Ansible is not installed. Please install ansible-core."
    exit 1
fi

print_success "Ansible is available"

# Check if playbook exists
if [[ ! -f "$SCRIPT_DIR/satellite_setup_playbook.yml" ]]; then
    print_error "Playbook not found: $SCRIPT_DIR/satellite_setup_playbook.yml"
    exit 1
fi

print_success "Integrated playbook found"

# Install required collections
print_status "Installing/updating required Ansible collections..."
ansible-galaxy collection install ansible.posix community.general --force-with-deps

print_header "Available Operations"
echo ""
echo "1. Interactive Deployment (recommended for first-time users)"
echo "2. Preflight Checks Only"
echo "3. Full Deployment (auto-detect host)"
echo "4. Quick Deployment"  
echo "5. Undo Previous Deployment"
echo "6. Advanced Options"
echo "7. Exit"
echo ""

read -p "Select an option [1-7]: " choice

case $choice in
    1)
        print_status "Starting interactive deployment with host selection..."
        ansible-playbook -i "$SCRIPT_DIR/inventory.ini" "$SCRIPT_DIR/satellite_setup_playbook.yml" \
            -e "interactive_mode=true" \
            -e "deployment_mode=full" \
            "$@"
        ;;
    2)
        print_status "Running preflight checks only..."
        ansible-playbook -i "$SCRIPT_DIR/inventory.ini" "$SCRIPT_DIR/satellite_setup_playbook.yml" \
            -e "deployment_mode=preflight" \
            "$@"
        ;;
    3)
        print_status "Starting full deployment..."
        ansible-playbook -i "$SCRIPT_DIR/inventory.ini" "$SCRIPT_DIR/satellite_setup_playbook.yml" \
            -e "deployment_mode=full" \
            "$@"
        ;;
    4)
        print_status "Starting quick deployment..."
        ansible-playbook -i "$SCRIPT_DIR/inventory.ini" "$SCRIPT_DIR/satellite_setup_playbook.yml" \
            -e "deployment_mode=quick" \
            -e "force_deployment=true" \
            "$@"
        ;;
    5)
        print_status "Starting undo operation..."
        ansible-playbook -i "$SCRIPT_DIR/inventory.ini" "$SCRIPT_DIR/satellite_setup_playbook.yml" \
            -e "undo_deployment=true" \
            -e "interactive_mode=true" \
            "$@"
        ;;
    6)
        echo ""
        print_header "Advanced Usage"
        echo "You can run the playbook directly with custom options:"
        echo ""
        echo "ansible-playbook -i inventory.ini satellite_setup_playbook.yml [OPTIONS]"
        echo ""
        echo "Available variables:"
        echo "  -e deployment_mode=preflight|full|quick"
        echo "  -e interactive_mode=true|false"
        echo "  -e undo_deployment=true|false"
        echo "  -e force_deployment=true|false"
        echo "  -e skip_preflight=true|false"
        echo "  -e skip_registration=true|false"
        echo ""
        echo "Examples:"
        echo "  # Interactive deployment with host selection:"
        echo "  ansible-playbook -i inventory.ini satellite_setup_playbook.yml -e 'interactive_mode=true'"
        echo ""
        echo "  # Undo deployment with confirmation:"
        echo "  ansible-playbook -i inventory.ini satellite_setup_playbook.yml -e 'undo_deployment=true'"
        echo ""
        echo "  # Force deployment despite warnings:"
        echo "  ansible-playbook -i inventory.ini satellite_setup_playbook.yml -e 'force_deployment=true'"
        echo ""
        ;;
    7)
        print_status "Exiting..."
        exit 0
        ;;
    *)
        print_error "Invalid option. Please select 1-7."
        exit 1
        ;;
esac

DEPLOYMENT_EXIT_CODE=$?

# Display results
echo ""
if [[ $DEPLOYMENT_EXIT_CODE -eq 0 ]]; then
    print_success "🎉 Operation completed successfully!"
    echo ""
    print_header "Next Steps"
    echo "• Use 'satellite-deploy.sh' again to run additional operations"
    echo "• Access Satellite web UI (if deployed): https://$(hostname)"
    echo "• Run health checks: ansible-playbook -i inventory.ini satellite_setup_playbook.yml -e 'deployment_mode=preflight'"
    echo "• Undo deployment: ansible-playbook -i inventory.ini satellite_setup_playbook.yml -e 'undo_deployment=true'"
else
    print_error "❌ Operation failed with exit code $DEPLOYMENT_EXIT_CODE"
    echo ""
    print_status "Troubleshooting tips:"
    echo "  1. Check the output above for specific error messages"
    echo "  2. Run with increased verbosity: $0 -vvv"
    echo "  3. Run preflight checks: ansible-playbook -i inventory.ini satellite_setup_playbook.yml -e 'deployment_mode=preflight'"
    echo "  4. Review the integrated playbook for detailed error handling"
    exit $DEPLOYMENT_EXIT_CODE
fi
