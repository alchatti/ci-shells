# Copilot Instructions for ci-shells

## Project Overview

This repository contains Docker images with a collection of shells for test drive purposes. The project is designed to provide a containerized environment with various shell utilities for testing and continuous integration workflows.

## Repository Structure

- `LICENSE` - MIT License for the project
- `README.md` - Project documentation
- `.github/` - GitHub-specific configuration files

## Coding Conventions

### General Guidelines

- Follow industry-standard best practices for Docker image creation
- Keep the repository minimal and focused on shell utilities
- Ensure all changes are well-documented in commit messages

### Docker Best Practices

- Use official base images when possible
- Minimize image layers for efficiency
- Include only necessary tools and dependencies
- Follow security best practices for container images
- Use multi-stage builds when appropriate

### Documentation

- Update README.md when adding new features or making significant changes
- Keep documentation concise and clear
- Document any special configuration requirements

## Development Workflow

### Making Changes

1. Create a descriptive branch name
2. Make focused, atomic commits
3. Write clear commit messages
4. Test changes in a containerized environment when applicable

### Testing

- Test Docker images build successfully before committing
- Verify shell utilities work as expected in the container
- Check for security vulnerabilities in dependencies

## License

This project is licensed under the MIT License. See LICENSE file for details.
