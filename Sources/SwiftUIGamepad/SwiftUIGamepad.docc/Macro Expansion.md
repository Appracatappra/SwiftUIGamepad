# Macro Expansion

Because of the requirements for several game engines and some specific connections to the host app, `SwiftUIGamepad` provides the ability to automatically expand macros written in the **Grace Language** (see https://github.com/Appracatappra/GraceLanguage) for many of its UI controls.

## Overview

When working with the `GamepadMenuView` controls, the items in the menu will automatically expand any **Grace Language Macros** in the text provided to the control. 

Internally, these controls call the `GraceRuntime.expandMacros` function to handle the text expansion. This allows the menu item to respond to changes in the app or game without the menu items having to be recreated.

### Expanding String Macros

The `GraceRuntime.expandMacros` function can expand **Grace Function Macros** inside of a given string by executing the named function and inserting the result in the string. For example:

```
let text = GraceRuntime.shared.expandMacros(in: "The answer is: @intMath(40,'+',2)")
```

After running the above code, the value of `text` will be `The answer is: 42`.

For more information, please see the **Grace Language** documentation.
