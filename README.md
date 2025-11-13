<h1 style="text-align:center; color:#1abc9c;">🚀 Corporate Battle Arena</h1>

<p style="text-align:center; font-size:16px;">
An interactive 1v1 multiplayer game for corporate employees, combining AI-powered quizzes, real-time battles, and fun challenges. Built with <strong>Flutter Flame</strong>, <strong>Firebase</strong>, and <strong>Gemini AI</strong> using <em>Clean Architecture</em>.
</p>

<hr style="border:1px solid #1abc9c;"/>

<h2 style="color:#3498db;">🔥 Features</h2>
<ul>
  <li>1v1 Real-Time Battles using Firebase (matchmaking & game state)</li>
  <li>AI-Powered Quiz System with Gemini AI — dynamic questions based on location</li>
  <li>Armor & Health system — players gain points, armor, and health</li>
  <li>Upgrade system — earn points to unlock weapons and planes</li>
  <li>Timed Rounds — health & armor recovery every 1 minute if no one dies</li>
  <li>Firebase Authentication for secure login</li>
  <li>Clean Architecture — Domain, Data, Presentation, Game Core</li>
</ul>

<h2 style="color:#3498db;">⚙️ Tech Stack</h2>
<table style="width:100%; border-collapse: collapse;">
<tr style="background-color:#ecf0f1;">
<th style="padding:8px; border:1px solid #ddd;">Layer</th>
<th style="padding:8px; border:1px solid #ddd;">Technology</th>
</tr>
<tr>
<td style="padding:8px; border:1px solid #ddd;">Frontend / Game Engine</td>
<td style="padding:8px; border:1px solid #ddd;">Flutter + Flame</td>
</tr>
<tr>
<td style="padding:8px; border:1px solid #ddd;">State Management</td>
<td style="padding:8px; border:1px solid #ddd;">Provider / Riverpod</td>
</tr>
<tr>
<td style="padding:8px; border:1px solid #ddd;">Dependency Injection</td>
<td style="padding:8px; border:1px solid #ddd;">GetIt + Injectable</td>
</tr>
<tr>
<td style="padding:8px; border:1px solid #ddd;">Backend / Realtime DB</td>
<td style="padding:8px; border:1px solid #ddd;">Firebase Firestore</td>
</tr>
<tr>
<td style="padding:8px; border:1px solid #ddd;">AI System</td>
<td style="padding:8px; border:1px solid #ddd;">Gemini AI SDK</td>
</tr>
<tr>
<td style="padding:8px; border:1px solid #ddd;">Auth System</td>
<td style="padding:8px; border:1px solid #ddd;">Firebase Authentication</td>
</tr>
<tr>
<td style="padding:8px; border:1px solid #ddd;">Architecture</td>
<td style="padding:8px; border:1px solid #ddd;">Clean Architecture (Domain, Data, Presentation)</td>
</tr>
</table>

<h2 style="color:#3498db;">🎮 Game Flow</h2>
<ol>
  <li>User login via Firebase (email / Google / corporate SSO)</li>
  <li>Matchmaking: paired with nearby player based on location</li>
  <li>Question Round: 5 AI-generated questions → points for correct answers</li>
  <li>Battle Phase: planes/armor fire automatically; damage calculated from points</li>
  <li>Timer Check: after 1 min, HP & armor regenerate if no one dies → new quiz round</li>
  <li>Game End: player whose HP reaches 0 loses; results saved to Firestore leaderboard</li>
</ol>

<h2 style="color:#3498db;">💻 Developer Setup</h2>
<pre style="background-color:#ecf0f1; padding:10px; border-radius:5px;">
# 1. Clone repo
git clone https://github.com/yourname/corporate-battle-arena.git

# 2. Install dependencies
flutter pub get

# 3. Generate DI files
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Configure Firebase
flutterfire configure

# 5. Run the game
flutter run
</pre>

<h2 style="color:#3498db;">❤️ Built By</h2>
<p>S M Tanvir Hasan (Faysal) <br>
Mobile App Developer | Flutter | Firebase | AI | Clean Architecture <br>
📧 faysaltanvir991@gmail.com <br>
🔗 <a href="https://www.linkedin.com/in/tanvir-hasan-faysal-243404229">LinkedIn</a> | 
<a href="https://github.com/Faysal9991">GitHub</a></p>
