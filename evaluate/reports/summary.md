# Evaluation Report

## Methodology

Benchmarks are run against real open-source repositories.
Token counts use a consistent `len(text) // 4` approximation.
Impact accuracy uses graph edges as ground truth.

## Token Efficiency

| repo | commit | description | changed_files | naive_tokens | standard_tokens | graph_tokens | naive_to_graph_ratio | standard_to_graph_ratio |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| code-review-graph | 528801f841e519567ef54d6e52e9b9831d162e1b | feat: add multi-platform MCP server installation support | 3 | 10858 | 4147 | 194794 | 0.1 | 0.0 |
| code-review-graph | 84bde35459c52e1e0c4b25c6c4799743021e0fc7 | feat: add Google Antigravity platform support for MCP install | 2 | 8113 | 394 | 184298 | 0.0 | 0.0 |
| express | 925a1dff1e42f1b393c977b8b77757fcf633e09f | fix: bump qs minimum to ^6.14.2 for CVE-2026-2391 | 1 | 682 | 82 | 1015 | 0.7 | 0.1 |
| express | b4ab7d65d7724d9309b6faaaf82ad492da2a6d35 | test: include edge case tests for res.type() | 1 | 703 | 510 | 77713 | 0.0 | 0.0 |
| fastapi | fa3588c38c7473aca7536b12d686102de4b0f407 | Fix typo for client_secret in OAuth2 form docstrings | 1 | 6045 | 299 | 179117 | 0.0 | 0.0 |
| fastapi | 0227991a01e61bf5cdd93cc00e9e243f52b47a4a | Exclude spam comments from statistics in scripts/people.py | 1 | 3844 | 735 | 120219 | 0.0 | 0.0 |
| flask | fbb6f0bc4c60a0bada0e03c3480d0ccf30a3c1df | all teardown callbacks are called despite errors | 10 | 72069 | 4656 | 385657 | 0.2 | 0.0 |
| flask | a29f88ce6f2f9843bd6fcbbfce1390a2071965d6 | document that headers must be set before streaming | 4 | 12917 | 1136 | 105469 | 0.1 | 0.0 |
| gin | 052d1a79aafe3f04078a2716f8e77d4340308383 | feat(render): add PDF renderer and tests | 5 | 44085 | 958 | 327229 | 0.1 | 0.0 |
| gin | 472d086af2acd924cb4b9d7be0525f7d790f69bc | fix(tree): panic in findCaseInsensitivePathRec with RedirectFixedPath | 2 | 13879 | 1347 | 95541 | 0.1 | 0.0 |
| gin | 5c00df8afadd06cc5be530dde00fe6d9fa4a2e4a | fix(render): write content length in Data.Render | 2 | 4702 | 517 | 147077 | 0.0 | 0.0 |
| httpx | ae1b9f66238f75ced3ced5e4485408435de10768 | Expose FunctionAuth in __all__ | 3 | 16816 | 267 | 157087 | 0.1 | 0.0 |
| httpx | b55d4635701d9dc22928ee647880c76b078ba3f2 | Upgrade Python type checker mypy | 4 | 7248 | 820 | 162960 | 0.0 | 0.0 |

## Impact Accuracy

| repo | commit | predicted_files | actual_files | true_positives | precision | recall | f1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| code-review-graph | 528801f841e519567ef54d6e52e9b9831d162e1b | 6 | 3 | 3 | 0.5 | 1.0 | 0.667 |
| code-review-graph | 84bde35459c52e1e0c4b25c6c4799743021e0fc7 | 3 | 2 | 2 | 0.667 | 1.0 | 0.8 |
| express | 925a1dff1e42f1b393c977b8b77757fcf633e09f | 2 | 1 | 1 | 0.5 | 1.0 | 0.667 |
| express | b4ab7d65d7724d9309b6faaaf82ad492da2a6d35 | 2 | 1 | 1 | 0.5 | 1.0 | 0.667 |
| fastapi | fa3588c38c7473aca7536b12d686102de4b0f407 | 1 | 1 | 1 | 1.0 | 1.0 | 1.0 |
| fastapi | 0227991a01e61bf5cdd93cc00e9e243f52b47a4a | 2 | 1 | 1 | 0.5 | 1.0 | 0.667 |
| flask | fbb6f0bc4c60a0bada0e03c3480d0ccf30a3c1df | 34 | 10 | 10 | 0.294 | 1.0 | 0.455 |
| flask | a29f88ce6f2f9843bd6fcbbfce1390a2071965d6 | 6 | 4 | 4 | 0.667 | 1.0 | 0.8 |
| gin | 052d1a79aafe3f04078a2716f8e77d4340308383 | 12 | 5 | 5 | 0.417 | 1.0 | 0.588 |
| gin | 472d086af2acd924cb4b9d7be0525f7d790f69bc | 5 | 2 | 2 | 0.4 | 1.0 | 0.571 |
| gin | 5c00df8afadd06cc5be530dde00fe6d9fa4a2e4a | 4 | 2 | 2 | 0.5 | 1.0 | 0.667 |
| httpx | ae1b9f66238f75ced3ced5e4485408435de10768 | 3 | 3 | 3 | 1.0 | 1.0 | 1.0 |
| httpx | b55d4635701d9dc22928ee647880c76b078ba3f2 | 7 | 4 | 4 | 0.571 | 1.0 | 0.727 |

## Flow Completeness

| repo | known_entry_points | detected_entry_points | recall | detected_flows | avg_flow_depth | max_flow_depth |
| --- | --- | --- | --- | --- | --- | --- |
| code-review-graph | 2 | 0 | 0.0 | 104 | 1.6 | 5 |
| express | 2 | 0 | 0.0 | 4 | 1.0 | 1 |
| fastapi | 2 | 2 | 1.0 | 165 | 1.8 | 6 |
| flask | 2 | 0 | 0.0 | 78 | 1.5 | 4 |
| gin | 2 | 1 | 0.5 | 114 | 1.4 | 5 |
| httpx | 2 | 2 | 1.0 | 128 | 2.7 | 10 |

## Search Quality

| repo | query | expected | rank | reciprocal_rank |
| --- | --- | --- | --- | --- |
| code-review-graph | GraphStore nodes | code_review_graph/graph.py::GraphStore | 0 | 0.0 |
| code-review-graph | parse AST | code_review_graph/parser.py::CodeParser | 0 | 0.0 |
| code-review-graph | full build | code_review_graph/incremental.py::full_build | 1 | 1.0 |
| express | app handle | lib/application.js::app | 0 | 0.0 |
| express | response send | lib/response.js::res | 0 | 0.0 |
| express | request | lib/request.js::req | 0 | 0.0 |
| fastapi | FastAPI application | fastapi/applications.py::FastAPI | 1 | 1.0 |
| fastapi | APIRoute routing | fastapi/routing.py::APIRoute | 1 | 1.0 |
| fastapi | Depends injection | fastapi/params.py::Depends | 0 | 0.0 |
| flask | Flask wsgi | src/flask/app.py::Flask | 1 | 1.0 |
| flask | AppContext globals | src/flask/ctx.py::AppContext | 0 | 0.0 |
| flask | create logger | src/flask/logging.py::create_logger | 1 | 1.0 |
| gin | Engine ServeHTTP | gin.go::Engine | 1 | 1.0 |
| gin | Context request | context.go::Context | 1 | 1.0 |
| gin | node tree | tree.go::node | 1 | 1.0 |
| httpx | Client request | httpx/_client.py::Client | 1 | 1.0 |
| httpx | Response headers | httpx/_models.py::Response | 0 | 0.0 |
| httpx | BaseClient | httpx/_client.py::BaseClient | 1 | 1.0 |

## Build Performance

| repo | file_count | node_count | edge_count | flow_detection_seconds | community_detection_seconds | search_avg_ms | nodes_per_second |
| --- | --- | --- | --- | --- | --- | --- | --- |
| code-review-graph | 92 | 1418 | 8877 | 0.021 | 0.041 | 0.3 | 68028 |
| express | 141 | 1912 | 18877 | 0.026 | 0.081 | 0.1 | 72296 |
| fastapi | 1128 | 6292 | 32081 | 0.072 | 0.18 | 0.1 | 86804 |
| flask | 86 | 1415 | 8259 | 0.019 | 0.041 | 0.3 | 75779 |
| gin | 98 | 1589 | 17237 | 0.028 | 0.068 | 0.4 | 57702 |
| httpx | 68 | 1261 | 8228 | 0.02 | 0.041 | 0.1 | 62691 |
