; extends

(keywords
  (pair
    key: (keyword) @_name 
    value: [
      (tuple (string (quoted_content) @injection.content))
      (string (quoted_content) @injection.content)
    ]
  )
  (#match? @_name "^graphql:\w?$")
  (#set! injection.language "graphql")
)
