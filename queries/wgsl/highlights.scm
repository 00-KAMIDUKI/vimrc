(identifier) @variable

(int_literal) @number

(float_literal) @number.float

(bool_literal) @boolean

(type_declaration
  (identifier) @type
)

(type_declaration) @type

(function_declaration
  (identifier) @function
)

(parameter
  (variable_identifier_declaration
    (identifier) @variable.parameter
  )
)

(struct_declaration
  (identifier) @type
)

(struct_declaration
  (struct_member
    (variable_identifier_declaration
      (identifier) @variable.member
    )
  )
)

(value_constructor) @type

[
  "const"
  "discard"
  "enable"
  "fallthrough"
  "let"
  "type"
  "var"
  "override"
  (texel_format)
] @keyword

"struct" @keyword.type

[
  "private"
  "storage"
  "uniform"
  "workgroup"
] @keyword.modifier

[
  "read"
  "read_write"
  "write"
] @keyword.modifier

"fn" @keyword.function

"return" @keyword.return

[
  ","
  "."
  ":"
  ";"
  "->"
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "<"
  ">"
] @punctuation.bracket

[
  "loop"
  "for"
  "while"
  "break"
  "continue"
  "continuing"
] @keyword.repeat

[
  "if"
  "else"
  "switch"
  "case"
  "default"
] @keyword.conditional

[
  "&"
  "&&"
  "/"
  "!"
  "="
  "%="
  "&="
  "*="
  "+="
  "-="
  "/="
  "^="
  "|="
  "=="
  "!="
  ">="
  ">>"
  "<="
  "<<"
  "%"
  "-"
  "+"
  "|"
  "||"
  "*"
  "~"
  "^"
  "++"
  "--"
] @operator

(attribute
  "@" @attribute
  (identifier) @attribute
)

(attribute
  "("
  (identifier) @variable
  ")"
)

[
  (line_comment)
  (block_comment)
] @comment @spell

(binary_expression
  [">" "<"] @operator
)

(type_constructor_or_function_call_expression
  (identifier) @function.call
)

(builtin_functions) @function.builtin
"bitcast" @function.builtin

(composite_value_decomposition_expression
  "."
  (identifier) @variable.member
)
