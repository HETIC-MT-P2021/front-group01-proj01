module Listing.Categories exposing (..)

import Html exposing (Html, Attribute, h1, map, text, div, ul, p)
import Html.Attributes exposing (class, href)
import Html.Events exposing (..)
import Json.Decode as Decode
import Time

type alias Category = 
    {
        id : Int,
        name : String,
        description : String,
        createdAt : String,
        updatedAt : String
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
        p [] [text category.name]

renderCategories : List Category -> Html msg
renderCategories categories =
    let 
        category =
            List.map renderCategory categories
    in
        ul [] category

type Msg 
    =  SetCategories (List Category)

update : Msg -> Model -> Model
update msg model =
    case msg of
    SetCategories items ->
            { model | listCategories = items }

view : Model -> Html msg
view model =
    div []
    [
        renderCategories model.listCategories
    ]
