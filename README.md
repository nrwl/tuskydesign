# NPM and Nx Monorepo Example

This repository is an example of a monorepo managed with [Nx](https://nx.dev).
It demonstrates how to structure and manage multiple TypeScript packages in a single repository.
The project follows the [Nx TypeScript Packages Tutorial](https://nx.dev/getting-started/tutorials/typescript-packages-tutorial).

## Features

- **Monorepo Management**: Centralized management of multiple TypeScript packages.
- **Code Sharing**: Reusable libraries shared across applications.
- **Dependency Graph**: Visualize and analyze dependencies between projects.
- **Task Pipelines**: Efficient execution of tasks with caching and parallelization.
- **Testing**: Unit testing for libraries and applications.
- **Build System**: Build and package libraries for distribution.

## Project Structure

The repository is organized as follows:

```
/packages   # Applications and libraries (e.g., web apps)
/nx.json    # Nx configuration
/package.json # Root package.json for dependencies
/tsconfig.base.json # Base TypeScript configuration
```

## Getting Started

### Prerequisites

- Node.js (>= 22.x)
- npm (>= 11.x)
- Nx CLI

### Installation

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd nx-monorepo-example
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

### Running Commands

Nx provides a set of commands to manage the monorepo. Below are the most commonly used commands:

#### 1. **Build a Project**

Build an application or library:

```bash
npm run build -w @tuskdesign/animals
npm run build -w @tuskdesign/zoo
```

#### 2. **Run a Project**

Run an application:

```bash
npm run serve -w @tuskdesign/zoo
```

#### 3. **Type check Projects**

Run type checking for all projects:

```bash
npx nx run-many -t typecheck
```

#### 4. **Build all Projects**

Build all applications and libraries:

```bash
npx nx run-many -t build
```

#### 5. **Analyze Dependencies**

Visualize the dependency graph:

```bash
npx nx graph
```

#### 6. **Show Affected Projects**

Show detailed information about the specified project

```bash
npx nx show project @tuskdesign/zoo
```

#### 7. **Run Affected Commands**

Run commands only for affected projects:

```bash
npx nx affected:build
npx nx affected:typecheck
```

## Pipelines

Nx uses task pipelines to optimize the execution of commands. Key features include:

- **Caching**: Nx caches the results of tasks to avoid redundant work.
- **Parallel Execution**: Tasks are executed in parallel when possible.
- **Affected Projects**: Nx determines which projects are affected by changes and runs tasks only for those projects.

# CI/CD Workflow Explanation

The `ci.yml` file defines a GitHub Actions workflow for automating CI/CD processes in a monorepo managed by Nx. Below is a detailed explanation of its structure and functionality:

### Workflow Name

```yaml
name: CI
```

The workflow is named `CI`, which stands for Continuous Integration. This name will appear in the GitHub Actions interface.

---

### Trigger Events

```yaml
on:
  push:
    branches:
      - main
      - "release/*"
      - "hotfix/*"
      - "bugfix/*"
  pull_request:
    branches:
      - main
```

The workflow is triggered by:

1. **Push Events**: When changes are pushed to the `main` branch or branches matching the patterns `release/*`, `hotfix/*`, or `bugfix/*`.
2. **Pull Request Events**: When a pull request targets the `main` branch.

This ensures the workflow runs for critical branches and pull requests, maintaining code quality and stability.

---

### Jobs

The workflow defines a single job named `nx-affected`.

#### Job Name and Runner

```yaml
jobs:
  nx-affected:
    name: Nx Affected (Build, Typecheck)
    runs-on: ubuntu-latest
```

- **Job Name**: `Nx Affected (Build, Typecheck)` describes the purpose of the job.
- **Runner**: The job runs on the `ubuntu-latest` virtual machine provided by GitHub.

---

### Steps

The job consists of several steps, each performing a specific task:

#### 1. Checkout Code

```yaml
- name: Checkout
  uses: actions/checkout@v4
  with:
    fetch-depth: 0
```

- Uses the `actions/checkout` action to clone the repository.
- `fetch-depth: 0` ensures the full commit history is fetched, which is necessary for Nx's `affected` commands to compare changes against the base branch.

#### 2. Set Up Node.js

```yaml
- name: Set up Node.js
  uses: actions/setup-node@v4
  with:
    node-version-file: "package.json"
    cache: "npm"
```

- Uses the `actions/setup-node` action to set up the Node.js environment.
- Reads the Node.js version from the `package.json` file.
- Enables caching of `node_modules` to speed up subsequent runs.

#### 3. Cache Nx

```yaml
- name: Cache Nx
  uses: actions/cache@v4
  with:
    path: |
      .nx/cache
    key: ${{ runner.os }}-nx-${{ hashFiles('nx.json', '**/project.json') }}
```

- Caches the Nx build cache (`.nx/cache`) to optimize performance.
- The cache key is generated based on the operating system and the hash of `nx.json` and all `project.json` files, ensuring the cache is invalidated when project configurations change.

#### 4. Install Dependencies

```yaml
- name: Install dependencies
  run: npm ci
```

- Installs dependencies using `npm ci`, which ensures a clean and deterministic installation based on the `package-lock.json` file.

#### 5. Run Affected Type Check

```yaml
- name: Run Affected Type Check
  run: npx nx affected --target=typecheck --base=origin/main --parallel=3
```

- Runs the `typecheck` target for only the affected projects (projects impacted by recent changes).
- Compares changes against the `main` branch.
- Executes tasks in parallel with up to 3 concurrent processes.

#### 6. Run Affected Build

```yaml
- name: Run Affected Build
  run: npx nx affected --target=build --base=origin/main --parallel=3
```

- Builds only the affected projects, similar to the type check step.
- Uses parallel execution to improve efficiency.

---

### Summary

This workflow is designed to:

1. Ensure only impacted projects are built and type-checked, optimizing CI/CD performance.
2. Leverage caching for dependencies and Nx to reduce redundant work.
3. Maintain code quality by running checks on critical branches and pull requests.

By focusing on affected projects, this workflow minimizes build times while ensuring the integrity of the monorepo.

## Customizing the Monorepo

You can customize the monorepo by modifying the following files:

- **`nx.json`**: Configure workspace-wide settings.
- **`workspace.json` or `project.json`**: Define project-specific configurations.
- **`tsconfig.base.json`**: Configure TypeScript paths for shared libraries.

## Resources

- [Nx Documentation](https://nx.dev)
- [Nx TypeScript Packages Tutorial](https://nx.dev/getting-started/tutorials/typescript-packages-tutorial)
- [Nx CLI Commands](https://nx.dev/cli)
- [Nx GitHub Actions](https://nx.dev/guides/github-actions)
