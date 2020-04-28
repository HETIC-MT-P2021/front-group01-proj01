module Route exposing (Route(..), parseUrl)

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), parse, Parser, oneOf, s, int)

type Route
    = NotFound
    | Home
    | Categories
    | Images
    | About
    | Category Int

parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Home (s "home")
        , Parser.map Categories (s "categories")
        , Parser.map Category (s "category" </> int)
        , Parser.map Images (s "images")
        , Parser.map About (s "about")
        ]