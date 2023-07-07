import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(BookshopApp());
}

class BookshopApp extends StatelessWidget {
  const BookshopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookshopAppState(),
      child: MaterialApp(
        title: 'Bookshop',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class Book {
  late String isbn;
  late String title;
  late int price;
  late String? cover;
  var synopsis = <String>[];

  Book(this.isbn, this.title, this.price, this.cover, this.synopsis);
}

class BookshopAppState extends ChangeNotifier {
  Book? current;
  var booksList = [
    Book(
        "c8fabf68-8374-48fe-a7ea-a00ccd07afff",
        "Henri Potier à l'école des sorciers",
        35,
        "https://firebasestorage.googleapis.com/v0/b/henri-potier.appspot.com/o/hp0.jpg?alt=media",
        [
          "Après la mort de ses parents (Lily et James Potier), Henri est recueilli par sa tante Pétunia (la sœur de Lily) et son oncle Vernon à l'âge d'un an. Ces derniers, animés depuis toujours d'une haine féroce envers les parents du garçon qu'ils qualifient de gens « bizarres », voire de « monstres », traitent froidement leur neveu et demeurent indifférents aux humiliations que leur fils Dudley lui fait subir. Henri ignore tout de l'histoire de ses parents, si ce n'est qu'ils ont été tués dans un accident de voiture",
          "Le jour des 11 ans de Henri, un demi-géant du nom de Rubeus Hagrid vient le chercher pour l’emmener à Poudlard, une école de sorcellerie, où il est inscrit depuis sa naissance et attendu pour la prochaine rentrée. Hagrid lui révèle alors qu’il a toujours été un sorcier, tout comme l'étaient ses parents, tués en réalité par le plus puissant mage noir du monde de la sorcellerie, Voldemort (surnommé « Celui-Dont-On-Ne-Doit-Pas-Prononcer-Le-Nom »), après qu'ils ont refusé de se joindre à lui. Ce serait Henri lui-même, alors qu'il n'était encore qu'un bébé, qui aurait fait ricocher le sortilège que Voldemort lui destinait, neutralisant ses pouvoirs et le réduisant à l'état de créature quasi-insignifiante. Le fait d'avoir vécu son enfance chez son oncle et sa tante dépourvus de pouvoirs magiques lui a donc permis de grandir à l'abri de la notoriété qu'il a dans le monde des sorciers.",
          "Henri entre donc à l’école de Poudlard, dirigée par le professeur Albus Dumbledore. Il est envoyé dans la maison Gryffondor par le « choixpeau ». Il y fait la connaissance de Ron Weasley et Hermione Granger, qui deviendront ses complices. Par ailleurs, Henri intègre rapidement l'équipe de Quidditch de sa maison, un sport collectif très populaire chez les sorciers se pratiquant sur des balais volants. Henri connaît probablement la plus heureuse année de sa vie, mais également la plus périlleuse, car Voldemort n'a pas totalement disparu et semble bien décidé à reprendre forme humaine."
        ]),
    Book(
        "a460afed-e5e7-4e39-a39d-c885c05db861",
        "Henri Potier et la Chambre des secrets",
        30,
        "https://firebasestorage.googleapis.com/v0/b/henri-potier.appspot.com/o/hp1.jpg?alt=media",
        [
          "Henri Potier passe l'été chez les Dursley et reçoit la visite de Dobby, un elfe de maison. Celui-ci vient l'avertir que des évènements étranges vont bientôt se produire à Poudlard et lui conseille donc vivement de ne pas y retourner. Henri choisit d'ignorer cet avertissement. Le jour de son départ pour l'école, il se retrouve bloqué avec Ron Weasley à la gare de King's Cross, sans pouvoir se rendre sur le quai 9 ¾ où les attend le Poudlard Express. En dernier recours, les garçons se rendent donc à Poudlard à l'aide de la voiture volante de Monsieur Weasley et manquent de peu de se faire renvoyer dès leur arrivée à l'école pour avoir été aperçus au cours de leur voyage par plusieurs moldus.",
          "Le nouveau professeur de défense contre les forces du mal, Gilderoy Lockhart, se montre particulièrement narcissique et inefficace. Pendant ce temps, Henri entend une voix étrange en parcourant les couloirs du château, systématiquement associée à la pétrification immédiate d'un élève moldu de l'école. Dès la première attaque, un message sanglant apparaît sur l'un des murs, informant que la Chambre des secrets a été ouverte. Dumbledore et les autres professeurs (ainsi que Henri, Ron et Hermione) doivent prendre les mesures nécessaires pour trouver l'identité du coupable et protéger les élèves contre de nouvelles agressions."
        ]),
  ];

  GlobalKey? historyListKey;

  void getBooks() {
    // booksList.addAll();
    notifyListeners();
  }

  var basket = <Book>[];

  void addOrRemoveFromBasket(Book book) {
    if (basket.contains(book)) {
      basket.remove(book);
    } else {
      basket.add(book);
    }
    notifyListeners();
  }

  void removeBook(Book book) {
    basket.remove(book);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = BooksPage();
        break;
      case 1:
        page = BasketPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Books',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Basket',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Books'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Basket'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}

class BooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<BookshopAppState>();
    var book = appState.current;
    var theme = Theme.of(context);

    var booksList = <Widget>[];
    for (var item in appState.booksList) {
      booksList.add(BookItem(book: item));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          // Make better use of wide windows with a grid.
          child: ListView(
            children: [
              for (var book in appState.booksList)
                ListTile(
                  leading: IconButton(
                    icon: appState.basket.contains(book)
                        ? const Icon(Icons.remove, size: 12)
                        : const Icon(Icons.add, size: 12),
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      appState.addOrRemoveFromBasket(book);
                    },
                  ),
                  title: Text(book.title),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class BookItem extends StatefulWidget {
  const BookItem({
    Key? key,
    required this.book,
  }) : super(key: key);

  final Book book;

  @override
  State<BookItem> createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<BookshopAppState>();

    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.book.title,
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.book.isbn,
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.addOrRemoveFromBasket(widget.book);
                  },
                  icon: appState.basket.contains(widget.book)
                      ? const Icon(Icons.add, size: 12)
                      : const Icon(Icons.remove, size: 12),
                  label: Text(widget.book.price.toString()),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BasketPage extends StatelessWidget {
  const BasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<BookshopAppState>();

    if (appState.basket.isEmpty) {
      return const Center(
        child: Text('No books in basket yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(50),
          child: Text('You have '
              '${appState.basket.length} books in your basket:'),
        ),
        Expanded(
          // Make better use of wide windows with a grid.
          child: ListView(
            children: [
              for (var book in appState.basket)
                ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.remove, semanticLabel: 'Remove'),
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      appState.removeBook(book);
                    },
                  ),
                  title: Text(
                    book.title,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
