import 'package:app_recipes/viewmodal/newsArticleViewModalList.dart';
import 'package:app_recipes/viewmodal/newsarticleViewModel.dart';
import 'package:app_recipes/widgets/listNews.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:app_recipes/widgets/detailsNews.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:app_recipes/widgets/loading.dart';

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String transcription = '';
  void requestPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.microphone);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.microphone]);
    }
  }

  final _controller = TextEditingController();
  Widget _appBarTitle = new Text('Search...');
  Icon _searchIcon = new Icon(Icons.search);
  @override
  void initState() {
    super.initState();
    activateSpeechRecognizer();
    Provider.of<NewsArticleViewModelList>(context, listen: false)
        .fetchlinesNews();
  }

  void activateSpeechRecognizer() {
    requestPermission();

    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  void start() => _speech
      .listen(locale: 'en_US')
      .then((result) => print('Started listening => result $result'));

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() => _speech.stop().then((result) {
        setState(() => _isListening = result);
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) =>
      setState(() => print("current locale: $locale"));

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) {
    final vm = Provider.of<NewsArticleViewModelList>(context);
    setState(() {
      transcription = text;
      print(transcription);

      // showSearchPage(context, _searchDelegate, transcription);
      vm.fetchlinesNewsbyKeywrd("covid");
      stop(); //stop listening now
    });
  }

  void onRecognitionComplete() => setState(() => _isListening = false);

  Widget _buildList(BuildContext context, NewsArticleViewModelList vm) {
    switch (vm.loadingStatus) {
      case LoadingStatus.searching:
        return Loading();
      case LoadingStatus.empty:
        return Align(child: Text("No results found!"));
      case LoadingStatus.completed:
        return Expanded(
            child: ListNews(
          articles: vm.articles,
          onSelected: (article) {
            _showNewsArticleDetails(context, article);
          },
        ));
    }
    return Container();
  }

  void _showNewsArticleDetails(
      BuildContext context, NewsarticleViewModal article) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewsArticleDetailsPage(article: article)));
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NewsArticleViewModelList>(context);
    void _searchPressed() {
      setState(() {
        if (this._searchIcon.icon == Icons.search) {
          this._searchIcon = new Icon(Icons.close);
          this._appBarTitle = new TextField(
            style: TextStyle(color: Colors.white),
            decoration: new InputDecoration(
              focusedBorder: InputBorder.none,
              hoverColor: Colors.white,
              border: InputBorder.none,
              focusColor: Colors.white,
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              hintText: 'Search...',
            ),
            onTap: () {
              _controller.clear();
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                vm.fetchlinesNewsbyKeywrd(value);
              }
            },
          );
        } else {
          this._searchIcon = new Icon(Icons.search);
          this._appBarTitle = new Text('Search Example');
        }
      });
    }

    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.indigo,
          centerTitle: true,
          title: _appBarTitle,
          actions: <Widget>[
            _buildVoiceInput(
              onPressed: _speechRecognitionAvailable && !_isListening
                  ? () => start()
                  : () => stop(),
              label: _isListening ? 'Listening...' : '',
            ),
          ],
          leading: new IconButton(
            icon: _searchIcon,
            onPressed: _searchPressed,
          ),
        ),
        body: Column(
          children: <Widget>[_buildList(context, vm)],
        ));
  }
}

Widget _buildVoiceInput({String label, VoidCallback onPressed}) => new Padding(
    padding: const EdgeInsets.all(12.0),
    child: Row(
      children: <Widget>[
        FlatButton(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        IconButton(
          icon: Icon(Icons.mic),
          onPressed: onPressed,
        ),
      ],
    ));
