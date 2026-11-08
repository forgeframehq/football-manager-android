package com.forgeframe.footballmanager;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class MainActivity extends Activity {
    private TextView infoText;
    private List<Player> squad = new ArrayList<>();
    private Random random = new Random();
    private int season = 1;
    private int wins = 0;
    private int losses = 0;

    private static class Player {
        String name;
        int rating; // 60-90
        String position;

        Player(String name, int rating, String position) {
            this.name = name;
            this.rating = rating;
            this.position = position;
        }

        @Override
        public String toString() {
            return name + " (" + position + ") - Rating: " + rating;
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Generate initial squad
        generateSquad();

        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setPadding(32, 32, 32, 32);

        TextView title = new TextView(this);
        title.setText("Football Manager 2026");
        title.setTextSize(24);
        title.setPadding(0, 0, 0, 20);
        layout.addView(title);

        infoText = new TextView(this);
        infoText.setTextSize(16);
        updateInfo();
        layout.addView(infoText);

        Button viewSquadBtn = new Button(this);
        viewSquadBtn.setText("View Squad");
        viewSquadBtn.setOnClickListener(v -> showSquad());
        layout.addView(viewSquadBtn);

        Button simulateBtn = new Button(this);
        simulateBtn.setText("Simulate Match");
        simulateBtn.setOnClickListener(v -> simulateMatch());
        layout.addView(simulateBtn);

        Button nextSeasonBtn = new Button(this);
        nextSeasonBtn.setText("Advance to Next Season");
        nextSeasonBtn.setOnClickListener(v -> nextSeason());
        layout.addView(nextSeasonBtn);

        ScrollView scroll = new ScrollView(this);
        scroll.addView(layout);
        setContentView(scroll);
    }

    private void generateSquad() {
        squad.clear();
        String[] positions = {"GK", "DEF", "DEF", "DEF", "DEF", "MID", "MID", "MID", "FWD", "FWD", "FWD"};
        String[] names = {"Alex", "Jordan", "Sam", "Taylor", "Casey", "Morgan", "Riley", "Jamie", "Drew", "Quinn", "Avery",
                          "Blake", "Cameron", "Dakota", "Emerson", "Finley", "Harper", "Jesse", "Kai", "Logan"};
        for (int i = 0; i < 11; i++) {
            String name = names[random.nextInt(names.length)] + " " + (char)('A' + random.nextInt(26));
            int rating = 65 + random.nextInt(20);
            squad.add(new Player(name, rating, positions[i]));
        }
    }

    private void updateInfo() {
        int avgRating = squad.stream().mapToInt(p -> p.rating).sum() / squad.size();
        infoText.setText("Season: " + season + "\nRecord: " + wins + "W - " + losses + "L\nTeam Avg Rating: " + avgRating);
    }

    private void showSquad() {
        StringBuilder sb = new StringBuilder("Your Squad:\n\n");
        for (Player p : squad) {
            sb.append(p.toString()).append("\n");
        }
        infoText.setText(sb.toString());
    }

    private void simulateMatch() {
        // Generate opponent
        int oppAvg = 65 + random.nextInt(25);
        int myAvg = squad.stream().mapToInt(p -> p.rating).sum() / squad.size();

        // Simple simulation
        int myGoals = Math.max(0, (myAvg - 60) / 8 + random.nextInt(4));
        int oppGoals = Math.max(0, (oppAvg - 60) / 8 + random.nextInt(4));

        String result;
        if (myGoals > oppGoals) {
            wins++;
            result = "WIN!";
        } else if (myGoals < oppGoals) {
            losses++;
            result = "LOSS";
        } else {
            result = "DRAW";
        }

        String msg = "Match Result: " + result + "\nScore: " + myGoals + " - " + oppGoals +
                     "\nYour Avg: " + myAvg + " | Opp Avg: " + oppAvg;
        infoText.setText(msg);
        Toast.makeText(this, result + " " + myGoals + "-" + oppGoals, Toast.LENGTH_SHORT).show();
        updateInfo();
    }

    private void nextSeason() {
        season++;
        // Improve some players slightly
        for (Player p : squad) {
            if (random.nextBoolean()) {
                p.rating = Math.min(95, p.rating + random.nextInt(3));
            }
        }
        wins = 0;
        losses = 0;
        updateInfo();
        Toast.makeText(this, "New season started! Squad improved.", Toast.LENGTH_SHORT).show();
    }
}
