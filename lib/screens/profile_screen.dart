import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:konvo_1/models/post_model.dart';
import 'package:konvo_1/models/user_data.dart';
import 'package:konvo_1/models/user_model.dart';
import 'package:konvo_1/screens/edit_profile_screen.dart';
import 'package:konvo_1/services/auth_service.dart';
import 'package:konvo_1/services/database_service.dart';
import 'package:konvo_1/utilities/constants.dart';
import 'package:konvo_1/widgets/post_view.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String userId;

  ProfileScreen({this.currentUserId, this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFollowing = false;
  int _followerCount = 0;
  int _followingCount = 0;
  List<Post> _posts = [];
  int _displayPosts = 0; // 0 - grid, 1 - column
  User _profileUser;

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowers();
    _setupFollowing();
    _setupPosts();
    _setupProfileUser();
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    setState(() {
      _isFollowing = isFollowingUser;
    });
  }

  _setupFollowers() async {
    int userFollowerCount = await DatabaseService.numFollowers(widget.userId);
    setState(() {
      _followerCount = userFollowerCount;
    });
  }

  _setupFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);
    setState(() {
      _followingCount = userFollowingCount;
    });
  }

  _setupPosts() async {
    List<Post> posts = await DatabaseService.getUserPosts(widget.userId);
    setState(() {
      _posts = posts;
    });
  }

  _setupProfileUser() async {
    User profileUser = await DatabaseService.getUserWithId(widget.userId);
    setState(() {
      _profileUser = profileUser;
    });
  }

  _followOrUnfollow() {
    if (_isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _unfollowUser() {
    DatabaseService.unfollowUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    setState(() {
      _isFollowing = false;
      _followerCount--;
    });
  }

  _followUser() {
    DatabaseService.followUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    setState(() {
      _isFollowing = true;
      _followerCount++;
    });
  }

  _displayButton(User user) {
    return user.id == Provider.of<UserData>(context).currentUserId
        ? Container(
      width: 200.0,
      child: FlatButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditProfileScreen(
              user: user,
            ),
          ),
        ),
        color: Colors.black,
        textColor: Colors.white,
        child: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    )
        : Container(
      width: 200.0,
      child: FlatButton(
        onPressed: _followOrUnfollow,
        color: _isFollowing ? Colors.grey[200] : Colors.blue,
        textColor: _isFollowing ? Colors.black : Colors.white,
        child: Text(
          _isFollowing ? 'Unfollow' : 'Follow',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }

  _buildProfileInfo(User user) {
    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              child: Stack(
                alignment: Alignment.bottomCenter,
                overflow: Overflow.visible,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 150.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: user.profileImageUrl.isEmpty
                                      ? AssetImage('assets/images/user_placeholder.jpg')
                                      : CachedNetworkImageProvider(user.profileImageUrl),)),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    top: 100.0,
                    child: Container(
                      height: 190.0,
                      width: 190.0,
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.grey,
                        backgroundImage: user.profileImageUrl.isEmpty
                            ? AssetImage('assets/images/user_placeholder.jpg')
                            : CachedNetworkImageProvider(user.profileImageUrl),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 120.0, 0.0, 0.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            0.0, 50.0, 15.0, 0.0),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  _posts.length.toString(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,color: Colors.white
                                  ),
                                ),
                                Text(
                                  'Moments',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  _followerCount.toString(),
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    color: Colors.lightGreen
                                  ),
                                ),
                                Text(
                                  'Fanbase',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  _followingCount.toString(),
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,color: Colors.white),
                                ),
                                Text(
                                  'Fan',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    _displayButton(user),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name,
                style: TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                height: 80.0,
                child: Text(
                  user.bio,
                  style: TextStyle(fontSize: 15.0,color: Colors.grey),
                ),
              ),
              Divider(),
            ],
          ),
        )
      ],
    );
  }

  _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on),
          iconSize: 30.0,
          color: _displayPosts == 0
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
          onPressed: () => setState(() {
            _displayPosts = 0;
          }),
        ),
        IconButton(
          icon: Icon(Icons.list),
          iconSize: 30.0,
          color: _displayPosts == 1
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
          onPressed: () => setState(() {
            _displayPosts = 1;
          }),

        ),
      ],
    );
  }

  _buildTilePost(Post post) {
    return GridTile(
      child: Image(
        image: CachedNetworkImageProvider(post.imageUrl),
        fit: BoxFit.cover,
      ),
    );
  }

  _buildDisplayPosts() {
    if (_displayPosts == 0) {
      // Grid
      List<GridTile> tiles = [];
      _posts.forEach(
            (post) => tiles.add(_buildTilePost(post)),
      );
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    } else {
      // Column
      List<PostView> postViews = [];
      _posts.forEach((post) {
        postViews.add(
          PostView(
            currentUserId: widget.currentUserId,
            post: post,
            author: _profileUser,
          ),
        );
      });
      return Column(children: postViews);
    }
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: AuthService.logout,
          ),
        ],
      ),
      body: FutureBuilder(
        future: usersRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);
          return ListView(
            children: <Widget>[
              _buildProfileInfo(user),
              _buildToggleButtons(),
              Divider(),
              _buildDisplayPosts(),
            ],
          );
        },
      ),
    );
  }
}
