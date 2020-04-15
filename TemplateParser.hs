module TemplateParser where

import Control.Applicative

import Parser

data ParsedValue
    = Text String
    | Noun
    | Adjective
    | Verb
    deriving (Show, Eq)

template_tag :: Parser ParsedValue
template_tag = char_parser '@' *> (f <$> tag_literal) <* char_parser '@'
    where tag_literal   = (string_parser "noun" <|> string_parser "adjective" <|> string_parser "verb")
          f "noun"      = Noun
          f "adjective" = Adjective
          f "verb"      = Verb
          -- should never happen
          f _           = undefined

template_text :: Parser ParsedValue
template_text = Text <$> not_null (span_parser (/= '@'))

template_parser :: Parser [ParsedValue]
template_parser = many (template_text <|> template_tag) <|> pure []