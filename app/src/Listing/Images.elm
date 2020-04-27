module Listing.Images exposing (..)

import Html exposing (Html, Attribute, h1, map, text, div, ul, p)
import Html.Attributes exposing (class, href)
import Html.Events exposing (..)
import Json.Decode as Decode
import Time

import Listing.Categories as Categories

type alias Image = 
    {
        id : Int,
        name : String,
        slug : String,
        description : String,
        createdAt : String,
        updatedAt : String,
        categoryId : Int,
        category : C
    }

type alias Model = 
    {
       listImages : List Image
    }

init : Model
init = 
    { listImages = 
        [ { id = 1,
            name = "Canard",
            slug = "YEHH65hefz",
            description = "Une image de canard",
            createdAt = "2020-05-27T16:43:58.0149453Z",
            updatedAt = "2020-05-27T16:43:58.0149453Z",
            categoryId = 1,
            category = {name = "Animaux"}
        },
        {
            id = 2,
            name = "Voiture",
            slug = "YEHH65hefz",
            description = "Une image de voiture",
            createdAt = "2020-06-27T16:43:58.0149453Z",
            updatedAt = "2020-06-27T16:43:58.0149453Z",
            categoryId = 2,
            category = {name = "Vehicule"}
        }]
    }

renderImage : Image -> Html msg
renderImage image =
        p [] [text image.name]

renderImages : List Image -> Html msg
renderImages images =
    let 
        image =
            List.map renderImage images
    in
        ul [] image

type Msg 
    =  SetImages (List Image)

update : Msg -> Model -> Model
update msg model =
    case msg of
    SetImages items ->
            { model | listImages = items }

view : Model -> Html msg
view model =
    div []
    [
        renderImages model.listImages
    ]
