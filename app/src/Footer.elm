module Footer exposing (init, update, Msg(..), Model, view)

import Html exposing (Html, a, ul, li, div, text, p)
import Html.Attributes exposing (class, href)

-- MODEL

type alias Author = 
    { name : String
    , mail : String
    }

type alias Model =
    { authors : List Author
    }

init : Model
init = 
    {
        authors = [ { name = "Athé Dussordet"
                    , mail = "marie-athenais.dussordet@hetic.net" }
                  , { name = "Alexandre Lellouche"
                    , mail = "alexandre.lellouche@hetic.net" }
                  , { name = "Thomas Raineau"
                    , mail = "thomas.raineau@hetic.net" }
                  ]  
    }

-- UPDATE

type Msg 
    = SetAuthors (List Author)

update : Msg -> Model -> Model
update msg model =
    case msg of
        SetAuthors items ->
            { model | authors = items }
-- VIEW

renderMailto : String -> String
renderMailto mail =
    String.append "mailto:" mail

renderAuthor : Author -> Html msg
renderAuthor author =
    a [ href (renderMailto author.mail), class "link" ] [ text author.name ]

renderAuthors : List Author -> Html msg
renderAuthors authors =
    let 
        author =
            List.map renderAuthor authors
    in
        ul [] author

view : Model -> Html msg
view model =
  div [ class "footer" ]
    [ p [] [ text "Image Gallery" ],
      renderAuthors model.authors ]