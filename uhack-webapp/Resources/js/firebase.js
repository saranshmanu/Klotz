  //Get elements 
$(document).ready(function() {

    var db = firebase.database();
    db.ref("live").on('child_added', snap => {
     
    //snapshot.forEach(function(snap){

      var amount= snap.child("amount").val();
      console.log(name);
    var date= snap.child("date").val();
    var from= snap.child("from").val();
    var time= snap.child("time").val();
    var to= snap.child("to").val();
     $('#blockTransaction').prepend("<tr><td>"+from+"</td><td>"+to+"</td><td>"+amount+"</td><td>"+date+"</td><td>"+time+"</td></tr>");
    

     // });

});

});
