#!/bin/bash

# Get the directory of the current script and use that to source the shell logger
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(dirname "$script_dir")"
source "$project_root/utils/shell_logger.sh"

update_package_lists() {
  log_info "Step: Updating package lists..."
  sudo apt update
  log_success "Package lists updated"
}

install_mise() {
  log_installing "Mise"
  curl https://mise.run | sh
  log_success "Mise installed"
}
install_git() {
  if ! command -v git &> /dev/null; then
    log_installing "Git 2+"
    sudo apt install -y git
    log_success "Git 2+ installed"
  else
    log_installed "Git 2+"
  fi
}

install_nodejs() {
  if ! command -v node &> /dev/null; then
    log_installing "Node.js 20.x"
    mise use node@lts
    log_success "Node.js 20.x installed"
  else
    log_installed "Node.js"
  fi
}

install_yarn() {
  if ! command -v yarn &> /dev/null; then
    log_installing "Yarn"
    npm install -g yarn
    log_success "Yarn installed"
  else
    log_installed "Yarn"
  fi
}

install_bun() {
  if ! command -v bun &> /dev/null; then
    log_installing "Bun"
    curl -fsSL https://bun.sh/install | bash
    log_success "Bun installed"
  else
    log_installed "Bun"
  fi
}

main() {
  update_package_lists || log_failure "Failed to update package lists"
  install_git || log_failure "Failed to install Git"
  install_mise || log_failure "Failed to install Mise"
  install_nodejs || log_failure "Failed to install Node.js"
  install_yarn || log_failure "Failed to install Yarn"
  install_bun || log_failure "Failed to install Bun"
}

main
