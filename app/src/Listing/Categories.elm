module Listing.Categories exposing (Msg(..), Model, init, update, view)

import Html exposing (Html, map, text, div, table, thead, tbody, td, tr, th, a)
import Html.Attributes exposing (class, href)
import Html.Events exposing (..)

type alias Category = 
    {
        id : Int
        , name : String
        , description : String
        , createdAt : String
        , updatedAt : String
    }

type alias Model = 
    {
       listCategories : List Category
    }

init : Model
init = 
    { listCategories = 
        [ { id = 1,
            name = "Animaux",
            description = "Des animaux",
            createdAt = "2020-05-27T16:43:58.0149453Z",
            updatedAt = "2020-05-27T16:43:58.0149453Z"
        },
        {
            id = 2,
            name = "Vehicules",
            description = "Des vehicules",
            createdAt = "2020-06-27T16:43:58.0149453Z",
            updatedAt = "2020-07-27T16:43:58.0149453Z"
        },
        {
            id = 3,
            name = "Paysages",
            description = "Des paysages",
            createdAt = "2020-08-27T16:43:58.0149453Z",
            updatedAt = "2020-08-27T16:43:58.0149453Z"
        }]
    }

renderCategory : Category -> Html msg
renderCategory category =
    let
        categoryUrl = "/category/" ++ String.fromInt category.id
    in
        tr[]
        [
            td[] [text (String.fromInt category.id)],
            td[] [text category.name],
            td[] [text category.description],
            td[] [text category.updatedAt],
            td[] [a [href categoryUrl][text "Voir"]]
        ]

renderCategories : List Category -> Html msg
renderCategories categories =
    let 
        category = List.map renderCategory categories
    in
        table [] 
        [
            thead[] 
            [
                tr []
                [
                    th [] [text "Identifiants"],
                    th [] [text "Nom"],
                    th [] [text "Description"],
                    th [] [text "Dernière MAJ"]
                ]
            ],
            tbody [] category
        ]

type Msg 
    =  SetCategories (List Category)

update : Msg -> Model -> Model
update msg model =
    case msg of
    SetCategories items ->
            { model | listCategories = items }

view : Model -> Html msg
view model =
    div [class "categories"]
    [
        renderCategories model.listCategories
    ]
