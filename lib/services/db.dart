import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voting_system/models/poll.dart';
import 'package:voting_system/services/auth.dart';

class DatabaseService {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  AuthService _authService = AuthService();

  Future<void> createUserData(String uid, String username, String email) async {
    return await _firebaseFirestore.collection("users").doc(uid).set(
      {'uid': uid, 'username': username, 'email': email, 'isAdmin': false},
    );
  }

  Future<bool> isUserAdmin() async {
    var document = await _firebaseFirestore
        .collection('users')
        .doc(_authService.getCurrentUserID())
        .get();
    return document.get('isAdmin');
  }

  Future createPoll(Poll poll) async {
    DocumentReference documentReference = await _firebaseFirestore
        .collection("polls")
        .add(_convertPollToMap(poll));
    FirebaseFirestore.instance
        .collection("polls")
        .doc(documentReference.id)
        .update({'voteBy': FieldValue.arrayUnion([])});

    poll.choices.forEach((Choice choice) async {
      await _firebaseFirestore
          .collection("polls")
          .doc(documentReference.id)
          .collection("choices")
          .add(_convertChoiceToMap(choice));
    });
  }

  Map<String, dynamic> _convertChoiceToMap(Choice choice) {
    Map<String, dynamic> map = {};
    map['title'] = choice.title;
    map['description'] = choice.description;
    map['votes'] = 0;
    return map;
  }

  Map<String, dynamic> _convertPollToMap(Poll poll) {
    Map<String, dynamic> map = {};
    map['title'] = poll.title;
    map['description'] = poll.description;
    map['isCompleted'] = false;
    map['popularChoice'] = "";
    return map;
  }

  Stream<List<Poll>> get activePolls {
    return _firebaseFirestore
        .collection("polls")
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => Poll(
                voteBy: documentSnapshot.data()['voteBy'],
                title: documentSnapshot.data()['title'],
                description: documentSnapshot.data()['description'],
                docID: documentSnapshot.id,
                isClosed: documentSnapshot.data()['isCompleted']))
            .toList());
  }

  Stream<List<Poll>> get inactivePolls {
    return _firebaseFirestore
        .collection("polls")
        .where('isCompleted', isEqualTo: true)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => Poll(
                title: documentSnapshot.data()['title'],
                description: documentSnapshot.data()['description'],
                isClosed: documentSnapshot.data()['isCompleted'],
                popularChoice: documentSnapshot.data()['popularChoice'],
                docID: documentSnapshot.id))
            .toList());
  }

  Future<Choice> getPopularChoice(String pollID) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection("polls")
        .doc(pollID)
        .collection("choices")
        .orderBy('votes', descending: true)
        .limit(1)
        .get();
    int mostVotes = querySnapshot.docs.first.get('votes');
    QuerySnapshot choices = await _firebaseFirestore
        .collection("polls")
        .doc(pollID)
        .collection("choices")
        .where('votes', isEqualTo: mostVotes)
        .get();
    Map<String, dynamic> doc = await querySnapshot.docs.first.data();
    Choice choice = Choice(
        title: doc['title'],
        description: doc['description'],
        votes: doc['votes']);
    return choice;
  }

  Future<void> changePollStatus(String pollID) async {
    String popularChoice =
        await getPopularChoice(pollID).then((value) => value.title);
    return await _firebaseFirestore
        .collection("polls")
        .doc(pollID)
        .update({'isCompleted': true, 'popularChoice': popularChoice});
  }

  Future<List<Choice>> getChoices(String docID) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection("polls")
        .doc(docID)
        .collection("choices")
        .get();
    return await querySnapshot.docs
        .map(
          (doc) => Choice(
            choiceID: doc.id,
            title: doc.data()['title'],
            description: doc.data()['description'],
            votes: doc.data()['votes'],
          ),
        )
        .toList();
  }

  Future vote(String pollID, String candidateID) async {
    await _firebaseFirestore.collection("polls").doc(pollID).update({
      'voteBy': FieldValue.arrayUnion([_authService.getCurrentUserID()])
    });
    return await _firebaseFirestore
        .collection("polls")
        .doc(pollID)
        .collection("choices")
        .doc(candidateID)
        .update({'votes': FieldValue.increment(1)});
  }

  Future<bool> candidateDraws(String pollID) async {
    int maxValue = await getPopularChoice(pollID).then((value) => value.votes);
    int numberOfTopVoteChoices = await _firebaseFirestore
        .collection("polls")
        .doc(pollID)
        .collection("choices")
        .where('votes', isEqualTo: maxValue)
        .get()
        .then((value) => value.docs.length);
    print("no." + numberOfTopVoteChoices.toString());
    return numberOfTopVoteChoices == 1 ? false : true;
  }
}
