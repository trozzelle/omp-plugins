# omp-plugins

An [OMP (oh-my-pi)](https://github.com/can1357/oh-my-pi) plugin marketplace.

## Use

```bash
omp plugin marketplace add trozzelle/omp-plugins     # once
omp plugin install <plugin>@trozzelle
omp plugin upgrade                                   # later: update every marketplace plugin
omp plugin uninstall <plugin>@trozzelle
```

OMP refreshes the catalog on its own once its cached copy is a day old; `omp plugin marketplace update trozzelle` checks right away. Inside OMP, `/marketplace` browses the catalog.

## Plugins

| Plugin | What it does | Needs |
| --- | --- | --- |
| [`omp-antigravity-bridge`](https://github.com/trozzelle/omp-antigravity-bridge) | Gemini models through Google's official Antigravity CLI as an OMP provider, a bridge that lets agy use your OMP tools, and the `AskAntigravity` delegation tool. | OMP 19.1+, the `agy` CLI installed and signed in |
| [`omp-rex`](https://github.com/trozzelle/omp-rex) | Rex terminal multiplexer integration: Program Resume (OSC 7577), synced `resume.trust.omp` rule generation, `REX_BLOCK` context awareness, and `/rex` diagnostics. | OMP 19.1+, Rex |

## How the catalog stays current

Each plugin repository publishes a `marketplace.json` with every release. The **Sync catalog** workflow here runs every six hours (and on demand), copies those plugin entries from each plugin's latest release into [`.omp-plugin/marketplace.json`](.omp-plugin/marketplace.json), and commits the change. An entry must point back at its own repository, or it is rejected. Plugin sources are listed at the top of [`scripts/sync-catalog.sh`](scripts/sync-catalog.sh).

## Switching from the release URL

If you added this marketplace through the long release URL (`…/releases/latest/download/marketplace.json`), swap the source; installed plugins stay installed:

```bash
omp plugin marketplace remove trozzelle
omp plugin marketplace add trozzelle/omp-plugins
```

## License

MIT.
