# Macro Expansion

Most of the UI controls in `SwiftUIGamepad` provide the ability to automatically expand macros written in the **Grace Language** for their displayed text.

## Overview

Because there are situations where `SwiftUIGamepad` UI controls need to respond to user interaction without having to be recreated, most of the UI controls in `SwiftUIGamepad` provide the ability to automatically expand macros written in the **Grace Language** (see https://github.com/Appracatappra/GraceLanguage for full details on Grace).

For example, when defining a `GamepadMenuItem` if you set the `title` to a string value containing a **Grace Macro**, the `GamepadMenuCardView` and `GamepadMenuItemView` controls will auto expand this text before display.

Internally, these controls call the `GraceRuntime.expandMacros` function to handle the text expansion. This allows the menu item to respond to changes in the app or game without the menu items having to be recreated.

> The following section if from the **Grace Language Documentation**. For full details on **Grace Macros** please see https://github.com/Appracatappra/GraceLanguage.

### Expanding String Macros

The `GraceRuntime.expandMacros` function can expand **Grace Function Macros** inside of a given string by executing the named function and inserting the result in the string. For example:

```
let text = GraceRuntime.shared.expandMacros(in: "The answer is: @intMath(40,'+',2)")
```

After running the above code, the value of `text` will be `The answer is: 42`.

For more information, please see the **Grace Language** documentation.
