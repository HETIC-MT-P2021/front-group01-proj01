module Pages.Image exposing (view, Msg, update, init, Model)

import Html exposing (Html, h1, map, text, div, span, button, input, ul, li, p)
import Html.Attributes exposing (class, type_, placeholder, value)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder)

import Header
import Footer

type alias UpdateForm = 
    { name: String
    , desc: String
    , tags: String
    , categoryName: String
    , id: Int
    }

init : Int -> ( Model, Cmd Msg )
init id =
    ( { header = Header.init
      , footer = Footer.init
      , imageId = id
      , imageData = Nothing
      , updateImageForm = 
        { name = ""
        , desc = ""
        , tags = ""
        , categoryName = ""
        , id = id
        }
      , error = Nothing
      }, Cmd.none )

type alias Model =
    { header: Header.Model
    , footer: Footer.Model
    , imageId: Int
    , imageData: Maybe Image
    , error: Maybe String
    , updateImageForm: UpdateForm
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

type Msg 
    = HeaderMsg Header.Msg
    | FooterMsg Footer.Msg
    | GetTheImage
    | GotItem (Result Http.Error (Image))
    | UpdateCategory String
    | UpdateName String
    | UpdateDesc String
    | UpdateTags String

getImage : Model -> Cmd Msg
getImage model = 
    let
        urlToCall = "http://localhost:8080/images/" ++ String.fromInt model.imageId
    in  
        Http.get
        { url = urlToCall
        , expect = Http.expectJson GotItem decodeImage
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

    GetTheImage ->
        (model, getImage model)

    GotItem (Ok image) ->
        ( { model | error = Nothing, imageData = Just image }, Cmd.none )

    GotItem (Err err) ->
        ( { model | error = Just <| errorToString err, imageData = Nothing }, Cmd.none )

    UpdateCategory category ->
        let
            oldForm = model.updateImageForm
            newForm = 
                { oldForm | categoryName = category}
        in
        ({ model | updateImageForm = newForm }, Cmd.none)

    UpdateName name ->
        let
            oldForm = model.updateImageForm
            newForm = 
                { oldForm | name = name}
        in
        ({ model | updateImageForm = newForm }, Cmd.none)
    
    UpdateDesc desc ->
        let
            oldForm = model.updateImageForm
            newForm = 
                { oldForm | desc = desc}
        in
        ({ model | updateImageForm = newForm }, Cmd.none)
    
    UpdateTags tags ->
        let
            oldForm = model.updateImageForm
            newForm = 
                { oldForm | tags = tags}
        in
        ({ model | updateImageForm = newForm }, Cmd.none)

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
                    h1 [] [ text "Page de l'image"],
                    span [] [text (String.fromInt model.imageId)]
                ]
        ]
        , div [class "form"]
            [
                p [] [text "Modifier l'image"]
                , div [class "form-content"]
                [ div []
                    [ text "Nom de l'image" ]
                , viewInput "text" "Nom" model.updateImageForm.name UpdateName
                , div [] [ text "Changer la description" ]
                , viewInput "text" "Description" model.updateImageForm.desc UpdateDesc
                , div [] [ text "Changer la catégorie" ]
                , viewInput "text" "Catégorie" model.updateImageForm.categoryName UpdateCategory
                , div [] [ text "Changer les tags" ]
                , viewInput "text" "tag1,tag2,tag3..." model.updateImageForm.tags UpdateTags
                , renderList (listTags model.updateImageForm.tags)
                , button [class "orange-btn"] [ text "Modifier l'image" ]
                ]
            ]
        , div [class "align-center"] [ button [class "orange-btn"] [ text "Supprimer l'image" ] ]
        , map FooterMsg (Footer.view model.footer)
    ]

viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []
  
listTags : String -> (List String)
listTags str =
  String.split "," str
  
renderList : List String -> Html msg
renderList lst =
    div []
        [ text "Liste de tags"
        , ul []
            (List.map (\l -> li [] [ text l ]) lst)
        ]
    