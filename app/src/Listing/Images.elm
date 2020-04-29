module Listing.Images exposing (..)

import Html exposing (Html, map, div, p, img, a, text, span)
import Html.Attributes exposing (class, href, src, width, height)
import Html.Events exposing (..)

-- This file is only meant to display hardcoded images on the home page

type alias Image = 
    { id: Int
    , name: String
    , slug: String
    , description: String
    , createdAt: String
    , updatedAt: String
    , url: String
    , tags: List String
    , categoryId: Maybe Int
    , categoryData: Maybe Category
    }

type alias Model = 
    {
       listImages: List Image
    }

type alias Category =
    { name: String
    , description: String
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
            url = "https://picsum.photos/200",
            tags = ["Animal", "Plumes"],
            categoryId = Just 1,
            categoryData = Nothing
        },
        {
            id = 2,
            name = "Voiture",
            slug = "YEHH65hefz",
            description = "Une image de voiture",
            createdAt = "2020-06-27T16:43:58.0149453Z",
            updatedAt = "2020-06-27T16:43:58.0149453Z",
            url = "https://picsum.photos/300",
            tags = ["Animal", "Plumes"],
            categoryId = Just 2,
            categoryData = Nothing
        },
        {
            id = 3,
            name = "Voiture",
            slug = "YEHH65hefz",
            description = "Une image de voiture",
            createdAt = "2020-06-27T16:43:58.0149453Z",
            updatedAt = "2020-06-27T16:43:58.0149453Z",
            url = "https://picsum.photos/250",
            tags = ["Animal", "Plumes"],
            categoryId = Just 2,
            categoryData = Nothing
        },
        {
            id = 4,
            name = "Voiture",
            slug = "YEHH65hefz",
            description = "Une image de voiture",
            createdAt = "2020-06-27T16:43:58.0149453Z",
            updatedAt = "2020-06-27T16:43:58.0149453Z",
            url = "https://picsum.photos/600",
            tags = ["Animal", "Plumes"],
            categoryId = Just 2,
            categoryData = Nothing
        },
        {
            id = 5,
            name = "Voiture",
            slug = "YEHH65hefz",
            description = "Une image de voiture",
            createdAt = "2020-06-27T16:43:58.0149453Z",
            updatedAt = "2020-06-27T16:43:58.0149453Z",
            url = "https://picsum.photos/1500",
            tags = ["Animal", "Plumes"],
            categoryId = Just 2,
            categoryData = Nothing
        }]
    }


renderTags : List String -> Html msg
renderTags tags =
    let 
        tag =
            List.map renderTag tags
    in
        div [class "image-tag-container"] tag

renderTag : String -> Html msg
renderTag tag =
    span[class "image-tag"] [text tag]

renderImages : List Image -> Html msg
renderImages images =
    let 
        image =
            List.map renderImage images
    in
        div [class "image-listing"] image

renderImage : Image -> Html msg
renderImage image =
    let
        imageRoute = "/image/" ++ String.fromInt image.id
    in
        div [class "image-item"]
        [
            a [href imageRoute] 
            [
                img [src image.url, width 300, height 300] []
                , div[class "image-text"] 
                [ p [class "image-name"] [text image.name]
                , p [] [text image.description]
                , p [] [text image.updatedAt]
                , renderTags image.tags
                ]
            ]
        ]

type Msg 
    =  SetImages (List Image)

update : Msg -> Model -> Model
update msg model =
    case msg of
    SetImages items ->
            { model | listImages = items }

view : Model -> Html msg
view model =
    div [] [renderImages model.listImages]
