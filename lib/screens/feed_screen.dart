
import 'package:flutter/material.dart';
import 'package:konvo_1/models/post_model.dart';
import 'package:konvo_1/models/user_model.dart';
import 'package:konvo_1/screens/create_post_screen.dart';
import 'package:konvo_1/services/database_service.dart';
import 'package:konvo_1/widgets/post_view.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';
  final String currentUserId;

  FeedScreen({this.currentUserId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _setupFeed();
  }

  _setupFeed() async {
    List<Post> posts = await DatabaseService.getFeedPosts(widget.currentUserId);
    setState(() {
      _posts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Konvo',
          style: TextStyle(
            color: Colors.yellow,
            fontFamily: 'Billabong',
            fontSize: 35.0,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _setupFeed(),
        child: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (BuildContext context, int index) {
            Post post = _posts[index];
            return FutureBuilder(
              future: DatabaseService.getUserWithId(post.authorId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                }
                User author = snapshot.data;
                return PostView(
                  currentUserId: widget.currentUserId,
                  post: post,
                  author: author,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.yellow,
        hoverColor: Colors.yellow,
        backgroundColor: Colors.blue,

        onPressed: ()=> Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CreatePostScreen(),
          ),
        ),

        tooltip: 'Post',
        child: Icon(Icons.add,),
      ),
    );
  }
}
