package com.example.yash1300.klotz;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;

public class MainActivity extends AppCompatActivity {
    EditText username, password;
    Button login;
    String usernameString, passString;
    FirebaseAuth mAuth;
    String userUID;
    ProgressDialog progressDialog;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        username = findViewById(R.id.loginUsername);
        password = findViewById(R.id.loginPassword);

        progressDialog = new ProgressDialog(this);
        progressDialog.setMessage("Logging in...");
        progressDialog.setCancelable(false);

        mAuth = FirebaseAuth.getInstance();

        login = findViewById(R.id.loginButton);
        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                usernameString = username.getText().toString();
                passString = password.getText().toString();
                progressDialog.show();

                if (usernameString.isEmpty() || passString.isEmpty()){
                    progressDialog.dismiss();
                    Toast.makeText(MainActivity.this, "Please fill all the details", Toast.LENGTH_LONG).show();
                } else {
                    progressDialog.dismiss();
                    mAuth.signInWithEmailAndPassword(usernameString, passString)
                            .addOnCompleteListener(MainActivity.this, new OnCompleteListener<AuthResult>() {
                                @Override
                                public void onComplete(@NonNull Task<AuthResult> task) {
                                    if (task.isSuccessful()) {
                                        Intent i = new Intent(MainActivity.this, MainScreen.class);
                                        i.putExtra("receivercode", "");
                                        i.putExtra("emailLoggedIn", usernameString);
                                        startActivity(i);
                                    } else {
                                        progressDialog.dismiss();
                                        Toast.makeText(MainActivity.this, "Wrong details entered", Toast.LENGTH_LONG).show();
                                    }
                                }
                            });

                }
            }
        });
    }
}
