module Pages.Images exposing (view, Msg, update, init, Model)

import Html exposing (Html, h1, map, text, div, p)
import Html.Attributes exposing (class)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder)

import Header
import Footer

type alias Model =
    { header: Header.Model
    , footer: Footer.Model
    , listImages: List Image
    , error: Maybe String
    }

type alias Image = 
    { id : Int
    , name: String
    , description: String
    , url: String
    , tags: List String
    , createdAt: String
    , updatedAt: String
    }

init : ( Model, Cmd Msg )
init =
    ( { header = Header.init
      , footer = Footer.init
      , listImages = []
      , error = Nothing
      }, Cmd.none )

type Msg 
    = HeaderMsg Header.Msg
    | FooterMsg Footer.Msg
    | GetAllImages
    | GotItems (Result Http.Error (List Image))

getImages : Cmd Msg
getImages = 
    Http.get
    { url = "http://localhost:8080/images"
    , expect = Http.expectJson GotItems (Decode.list decodeImage)
    }

decodeImage : Decoder Image
decodeImage =
    Decode.map7 Image
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "url" Decode.string)
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

    GetAllImages ->
        (model, getImages)

    GotItems (Ok images) ->
        ( { model | error = Nothing, listImages = images }, Cmd.none )

    GotItems (Err err) ->
        ( { model | error = Just <| errorToString err, listImages = [] }, Cmd.none )

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
    div []
    [
        map HeaderMsg (Header.view model.header)
        , div[class "content"]
        [
            div []
                [ 
                    h1 [] [ text "Page des images" ]
                    ,p [] [ text "Sur cette page seront listés les images"] 
                ]
        ]
        , map FooterMsg (Footer.view model.footer)
    ]