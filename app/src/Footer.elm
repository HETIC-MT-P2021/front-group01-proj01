module Footer exposing (init, update, Msg(..), Model, view)

import Html exposing (Html, a, ul, li, div, text, p, h1, h3, i)
import Html.Attributes exposing (class, href)

-- MODEL

type alias Author = 
    { name : String
    , github : String
    }

type alias Model = { authors : List Author}

init : Model
init = 
    {
        authors = [ { name = "Athé Dussordet"
                    , github = "https://github.com/Araknyfe" }
                  , { name = "Alexandre Lellouche"
                    , github = "https://github.com/AlexandreLch" }
                  , { name = "Thomas Raineau"
                    , github = "https://github.com/Traineau" }
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

renderAuthor : Author -> Html msg
renderAuthor author =
    a [ href author.github] [ li [] [text author.name]]

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
    [
        div [ class "inner-footer" ]
        [
            div [ class "footer-items" ]
            [ 
                h1 [] [ text "Gollery" ],
                p [] [ text "Cette galerie d'image est un projet éducatif." ]
            ],
            div [ class "footer-items" ]
            [
                h3 [] [ text "Liens annexes" ],
                div [ class "border1" ] [],
                ul []
                [
                    a [href "/home"] [ li [] [text "Accueil"]],
                    a [href "/about"] [ li [] [text "A propos"]],
                    a [href "/contact"] [ li [] [text "Contact"]]
                ]
            ],
            div [ class "footer-items" ]
            [
                h3 [] [ text "Les auteurs" ],
                div [ class "border1" ] [],
                renderAuthors model.authors
            ],
            div [ class "footer-items" ]
            [
                h3 [] [ text "Nous contacter" ],
                div [ class "border1" ] [],
                ul []
                [
                    a [href "/#"] [ li [] [ i[class "fa fa-map-marker"][], text "XYZ, abc"] ],
                    a [href "/#"] [ li [] [ i[class "fa fa-phone"][], text "123456789"] ],
                    a [href "/#"] [ li [] [ i[class "fa fa-envelope"][], text "xy@gmail.com"] ]
                ],
                div[class "social-media"][
                    a [href "/#"] [ i [class "fab fa-instagram"][] ],
                    a [href "/#"] [ i [class "fab fa-facebook"][] ],
                    a [href "/#"] [ i [class "fab fa-linkedin"][] ]
                ]
            ],
            div[class "footer-bottom"]
            [
                text "Copyright © Hetic under the MIT License."
            ]
        ]
    ]