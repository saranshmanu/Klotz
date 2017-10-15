package com.example.yash1300.klotz;

import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.journeyapps.barcodescanner.BarcodeEncoder;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class MainScreen extends AppCompatActivity {
ListView listView;
List<Transaction> transactions;
TextView cardholder, balance, exchangeRate;
Button send;
String receiverCode, email, balanceLeft, emailLoggedIn, senderName, userUID;
ImageView qrCode;
FirebaseDatabase database;
ProgressDialog progressDialog;
    @Override
    protected void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_screen);

        receiverCode = getIntent().getExtras().getString("receivercode");
        emailLoggedIn = getIntent().getExtras().getString("emailLoggedIn");

        progressDialog = new ProgressDialog(this);
        progressDialog.setMessage("Loading...");
        progressDialog.setCancelable(false);
        progressDialog.show();

        cardholder = findViewById(R.id.cardHolder);
        balance = findViewById(R.id.balance);
        send = findViewById(R.id.sendButton);
        qrCode = findViewById(R.id.qrCode);


        exchangeRate = findViewById(R.id.exchangeRate);
        StringRequest stringRequest = new StringRequest(Request.Method.GET, "https://blockchain.info/ticker", new Response.Listener<String>() {
            @Override
            public void onResponse(String s) {
                try {
                    JSONObject jsonObject = new JSONObject(s);
                    String rate = jsonObject.getJSONObject("INR").getString("15m");
                    exchangeRate.setText(rate);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError volleyError) {
                volleyError.printStackTrace();
            }
        });
        Volley.newRequestQueue(MainScreen.this).add(stringRequest);
        database = FirebaseDatabase.getInstance();
        DatabaseReference myRef = database.getReference("users");
        myRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                Iterable<DataSnapshot> everything = dataSnapshot.getChildren();
                for (DataSnapshot something: everything){
                    email = something.child("profile").child("email").getValue(String.class);
                    if (email.equals(emailLoggedIn)){
                        progressDialog.dismiss();
                        senderName = something.child("profile").child("name").getValue(String.class);
                        balanceLeft = something.child("finance").child("balance").getValue(String.class);
                        cardholder.setText(senderName);
                        balance.setText(balanceLeft + " Klotz");
                        userUID = something.getKey();
                        MultiFormatWriter multiFormatWriter = new MultiFormatWriter();
                        try {
                            BitMatrix matrix = multiFormatWriter.encode(emailLoggedIn, BarcodeFormat.QR_CODE, 200,200);
                            BarcodeEncoder barcodeEncoder = new BarcodeEncoder();
                            Bitmap bitmap = barcodeEncoder.createBitmap(matrix);
                            qrCode.setImageBitmap(bitmap);
                        } catch (WriterException e) {
                            e.printStackTrace();
                        }
                        break;
                    }
                }
            }

            @Override
            public void onCancelled(DatabaseError databaseError) {
                progressDialog.dismiss();
                userUID = "error";
                Toast.makeText(MainScreen.this, "Some problem occured", Toast.LENGTH_LONG).show();
            }
        });
        myRef.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                Iterable<DataSnapshot> everything = dataSnapshot.getChildren();
                for (DataSnapshot something: everything){
                    email = something.child("profile").child("email").getValue(String.class);
                    if (email.equals(emailLoggedIn)){
                        progressDialog.dismiss();
                        senderName = something.child("profile").child("name").getValue(String.class);
                        balanceLeft = something.child("finance").child("balance").getValue(String.class);
                        cardholder.setText(senderName);
                        balance.setText(balanceLeft + " Klotz");
                        userUID = something.getKey();
                        MultiFormatWriter multiFormatWriter = new MultiFormatWriter();
                        try {
                            BitMatrix matrix = multiFormatWriter.encode(emailLoggedIn, BarcodeFormat.QR_CODE, 200,200);
                            BarcodeEncoder barcodeEncoder = new BarcodeEncoder();
                            Bitmap bitmap = barcodeEncoder.createBitmap(matrix);
                            qrCode.setImageBitmap(bitmap);
                        } catch (WriterException e) {
                            e.printStackTrace();
                        }
                        break;
                    }
                }
            }

            @Override
            public void onCancelled(DatabaseError databaseError) {
                progressDialog.dismiss();
                userUID = "error";
                Toast.makeText(MainScreen.this, "Some error occured", Toast.LENGTH_LONG).show();
            }
        });



        if (!receiverCode.equals("")){
            AlertDialog.Builder  builder = new AlertDialog.Builder(MainScreen.this);
            View v = LayoutInflater.from(MainScreen.this).inflate(R.layout.amount_send_dialog, null, false);
            builder.setView(v);
            final AlertDialog sendDialog = builder.create();
            sendDialog.show();
            EditText receiverCodeEditText, amountToBeSent;
            Button sendItFinally;
            receiverCodeEditText = v.findViewById(R.id.holderReceivingTheAmount);
            amountToBeSent = v.findViewById(R.id.amountToBeSent);
            sendItFinally = v.findViewById(R.id.sendItFinally);

            receiverCodeEditText.setText(receiverCode);

            sendItFinally.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    sendDialog.dismiss();
                }
            });

        } else {

        }

        send.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(MainScreen.this, qrCameraActivity.class);
                i.putExtra("emailLoggedIn", emailLoggedIn);
                startActivity(i);
            }
        });


        listView = findViewById(R.id.transactionList);
        transactions = new ArrayList<>();
        Transaction item = new Transaction("Food", "16 Oct'17", "20 INR", 0);
        transactions.add(item);
        Transaction item2 = new Transaction("Clothes", "17 Oct'17", "10 INR", 0);

        transactions.add(item2);
        transactions.add(new Transaction("Laundry", "18 Oct'17", "40 INR", 0));
        transactions.add(new Transaction("Class", "19 Oct'17", "30 INR", 1));
        CustomListAdapter customListAdapter = new CustomListAdapter(MainScreen.this, transactions);
        listView.setAdapter(customListAdapter);
    }
}
