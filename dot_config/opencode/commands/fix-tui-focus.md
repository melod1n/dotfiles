---
description: Fix TUI focus and keyboard navigation only
agent: build
---

Fix only TUI focus and keyboard navigation behavior.

Requirements:
- Tab moves focus forward.
- Shift+Tab moves focus backward.
- Escape closes the topmost modal/dialog.
- Dialogs trap focus while open.
- Enter activates only the currently focused confirmable element.
- Preserve existing layout unless a layout bug directly causes the focus issue.
- Do not redesign unrelated UI.
- Do not change unrelated shortcuts.

Issue:

$ARGUMENTS
