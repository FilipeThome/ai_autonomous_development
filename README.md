# Kotlin AI Autonomous

An autonomous AI engineering framework for Kotlin and Spring Boot projects.

This repository provides a structured multi-agent workflow that enables AI assistants to act as a software engineering team, enforcing architecture reviews, testing, validation, memory-driven learning, and continuous quality improvement.

## Overview

The system is designed around specialized AI agents that collaborate to analyze, design, implement, test, review, and continuously improve software solutions.

Core principles:

- Architecture-first development
- Mandatory validation before completion
- Automated quality enforcement
- Memory-driven learning
- Self-healing workflows
- Log-driven diagnostics
- Continuous improvement loops

## Architecture

```text
User Request
      │
      ▼
 ┌─────────────┐
 │ Orchestrator│
 └──────┬──────┘
        │
        ▼
 ┌─────────────┐
 │ Architect   │
 └──────┬──────┘
        │
        ▼
 ┌─────────────┐
 │ Backend Dev │
 └──────┬──────┘
        │
        ▼
 ┌─────────────┐
 │ Test Agent  │
 └──────┬──────┘
        │
        ▼
 ┌─────────────┐
 │ Reviewer    │
 └──────┬──────┘
        │
        ▼
 Validation Loop
        │
        ▼
      Done
```

## Features

### Multi-Agent Workflow

- Architect
- Backend Engineer
- Test Engineer
- Reviewer

### Memory System

Stores learned rules, architectural constraints, error patterns, and project context.

### Autonomous Diagnostics

Supports log analysis, root-cause detection, and self-healing workflows.

### Continuous Learning

Tracks mistakes, fixes, patterns, and lessons learned.

## Repository Structure

```text
.
├── CLAUDE.md
├── ai
├── memory
├── scripts
└── .claude
```

## Workflow

1. Context Loading
2. Architecture Validation
3. Development
4. Testing
5. Review
6. Continuous Improvement

## Definition of Done

- Code compiles
- Tests pass
- Architecture approved
- Memory rules respected
- Quality checks completed

## License

Add your preferred license here.
