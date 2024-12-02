# Nx NPM Workspaces Tutorial

Following along with the tutorial here: https://nx.dev/getting-started/tutorials/npm-workspaces-tutorial

Add nx to a workspace: 
```bash
npx nx@latest init
```

See the project dependency graph (dynamically derived from codebase):
```bash
npx nx graph --focus=@tuskdesign/zoo
```

Run task for specific package/library:
```bash
npx nx build @tuskdesign/zoo
```

Run all tasks with a specific name:
```bash
npx nx run-many -t typecheck
```

After creating a new library, moving code into it, and updating references to code, rebuild the workspace to sync the workspace:
```bash
npx nx run-many -t build
```

To create a CI workflow:
```bash
npx nx connect

npx nx generate @nx/workspace:ci-workflow --ci-github
```