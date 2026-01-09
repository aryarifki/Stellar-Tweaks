## 2024-05-23 - Shell Script Performance Optimization
**Learning:** Shell built-ins like `read` are orders of magnitude faster (100x+) than external commands like `cat` for reading small files in loops. Similarly, avoid unnecessary `chmod` calls if writing is possible.
**Action:** Replace `$(cat file)` with `read -r val < file` and optimize write patterns to try writing before changing permissions.
