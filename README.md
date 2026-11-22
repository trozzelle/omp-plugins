# omp-plugins

An [OMP (oh-my-pi)](https://github.com/can1357/oh-my-pi) plugin marketplace.

```bash
omp plugin marketplace add trozzelle/omp-plugins
omp plugin install omp-antigravity-bridge@trozzelle
```

Keep plugins current with:

```bash
omp plugin upgrade
```

OMP refreshes the catalog on its own when its cached copy is older than 24 hours; `omp plugin marketplace update trozzelle` checks right away.

## Plugins

| Plugin | Description |
| --- | --- |
| [`omp-antigravity-bridge`](https://github.com/trozzelle/omp-antigravity-bridge) | Gemini models through Google's official Antigravity CLI (`agy`) as an OMP provider, plus the `AskAntigravity` delegation tool. Requires `agy`, installed and signed in. Docs: [docs/OMP.md](https://github.com/trozzelle/omp-antigravity-bridge/blob/main/docs/OMP.md). |

## How the catalog stays current

Each plugin repository publishes a `marketplace.json` with every release. The **Sync catalog** workflow in this repository runs every six hours (and on demand), copies the plugin entries from each plugin's latest release into [`.omp-plugin/marketplace.json`](.omp-plugin/marketplace.json), and commits the change. Entries must point back at their own repository; anything else is rejected.

## Switching from the release URL

If you added this marketplace earlier through the long release URL (`…/releases/latest/download/marketplace.json`), swap the source; the installed plugin stays installed:

```bash
omp plugin marketplace remove trozzelle
omp plugin marketplace add trozzelle/omp-plugins
```
