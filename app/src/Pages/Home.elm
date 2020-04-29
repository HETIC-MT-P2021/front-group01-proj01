module Pages.Home exposing (view, Msg, update, init, Model)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder)

import Header
import Footer

-- Those will display images and categories coded by hand
-- As our http.get returns nothing
-- So we will see how the images and Categories display
import Listing.Categories as Categories
import Listing.Images as Images

type alias Category = 
    {
        id : Int
        , name : String
        , description : String
        , createdAt : String
        , updatedAt : String
    }

type alias Image = 
    {
        id : Int
        , name : String
        , description : String
        , url : String
        , category : Category
        , tags : List String
        , createdAt : String
        , updatedAt : String
    }

type alias Model =
    { 
        header: Header.Model
        , footer: Footer.Model
        , categories: Categories.Model -- The hardcoded categories for the demo
        , images: Images.Model -- The hardcoded images for the demo
        , lastCategories: List Category
        , lastImages: List Image
        , error: Maybe String
    }

init : ( Model, Cmd Msg )
init =
    ( { header = Header.init
      , footer = Footer.init
      , categories = Categories.init
      , images = Images.init
      , lastCategories = []
      , lastImages = []
      , error = Nothing
      }, getLastCategories )

type Msg 
    = HeaderMsg Header.Msg
    | FooterMsg Footer.Msg
    | CategoriesMsg Categories.Msg
    | ImagesMsg Images.Msg
    | GetLastCategories
    | GotCategories (Result Http.Error (List Category))
    | GetLastImages
    | GotImages (Result Http.Error (List Image))

getLastCategories : Cmd Msg
getLastCategories = 
    Http.get
    { url = "http://localhost:8080/categories?updated_at=desc"
    , expect = Http.expectJson GotCategories (Decode.list decodeCategory)
    }

decodeCategory : Decoder Category
decodeCategory =
    Decode.map5 Category
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "createdAt" Decode.string)
        (Decode.field "updatedAt" Decode.string)

getLastImages : Cmd Msg
getLastImages = 
    Http.get
    { url = "http://localhost:8080/images?updated_at=desc"
    , expect = Http.expectJson GotImages (Decode.list decodeImage)
    }

decodeImage : Decoder Image
decodeImage =
    Decode.map8 Image
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "url" Decode.string)
        (Decode.field "category" decodeCategory)
        (Decode.field "tags" (Decode.list Decode.string))
        (Decode.field "createdAt" Decode.string)
        (Decode.field "updatedAt" Decode.string)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
    HeaderMsg headerMsg ->
        ( { model | header = Header.update headerMsg model.header }, Cmd.none )

    FooterMsg footerMsg ->
        ( { model | footer = Footer.update footerMsg model.footer }, Cmd.none )

    CategoriesMsg categoriesMsg ->
        ( { model | categories = Categories.update categoriesMsg model.categories }, Cmd.none )

    ImagesMsg imagesMsg ->
        ( { model | images = Images.update imagesMsg model.images }, Cmd.none )

    GetLastCategories ->
        (model, getLastCategories)

    GotCategories (Ok categories) ->
        ( { model | error = Nothing, lastCategories = categories }, Cmd.none )

    GotCategories (Err err) ->
        ( { model | error = Just <| errorToString err, lastCategories = [] }, Cmd.none )
    
    GetLastImages ->
        (model, getLastImages)

    GotImages (Ok images) ->
        ( { model | error = Nothing, lastImages = images }, Cmd.none )

    GotImages (Err err) ->
        ( { model | error = Just <| errorToString err, lastImages = [] }, Cmd.none )


errorToString : Http.Error -> String
errorToString error =
    case error of
        BadUrl url ->
            "Bad url: " ++ url

        Timeout ->
            "Request timed out."

        NetworkError ->
            "Network error. Are you online?"

        BadStatus status_code ->
            "HTTP error " ++ String.fromInt status_code

        BadBody body ->
            "Unable to parse response body: " ++ body

view : Model -> Html Msg
view model =
    div[]
    [
        Html.map HeaderMsg (Header.view model.header)
        , div[class "content"]
        [
            
            div []
                [ 
                    h1 [] [ text "Page home" ] 
                ]
            , h2 [] [text "Dernières catégories ajoutées"]
            , p[] [text "Ce tableau est vide dû au non fonctionnement de Http.get"]
            , div [class "categories"]
                [
                    renderCategories model.lastCategories
                ]
            , div []
            [ button [ onClick GetLastCategories ]
                [ text "Actualiser les catégories" ]
            ]
            , h2 [] [text "Exemple d'affichage de catégories"]
            , Html.map CategoriesMsg (Categories.view model.categories)
            , h2 [] [text "Exemple d'affichage d'images"]
            , Html.map ImagesMsg (Images.view model.images)
        ]
        , Html.map FooterMsg (Footer.view model.footer)
    ]
        
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
