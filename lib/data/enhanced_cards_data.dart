import 'package:flutter/material.dart';
import '../models/enhanced_card.dart';

// ─── Domain Image URLs (Unsplash, CORS-safe) ──────────────────────────────────
const Map<String, String> domainSceneImages = {
  'workplace': 'https://images.unsplash.com/photo-1521737711867-e3b97375f902?w=600&fit=crop&auto=format',
  'relationship': 'https://images.unsplash.com/photo-1516585427167-9f4af9627e6c?w=600&fit=crop&auto=format',
  'character': 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=600&fit=crop&auto=format',
  'daily': 'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=600&fit=crop&auto=format',
  'communication': 'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=600&fit=crop&auto=format',
  'social': 'https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=600&fit=crop&auto=format',
  'coping': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=600&fit=crop&auto=format',
  'selfadvocacy': 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=600&fit=crop&auto=format',
};

// ─── Domain Definitions ───────────────────────────────────────────────────────
final Map<String, DomainInfo> enhancedDomains = {
  'workplace': DomainInfo(
    key: 'workplace',
    label: 'Workplace Skills',
    description: 'Skills for success on the job and in vocational settings',
    color: const Color(0xFF1F3E66),
    soft: const Color(0xFFDDE4ED),
    icon: 'briefcase',
  ),
  'relationship': DomainInfo(
    key: 'relationship',
    label: 'Relationship Skills',
    description: 'Building and maintaining positive connections with others',
    color: const Color(0xFF5B3A7A),
    soft: const Color(0xFFE6DEED),
    icon: 'users',
  ),
  'character': DomainInfo(
    key: 'character',
    label: 'Character Strengths',
    description: 'Core values and personal integrity',
    color: const Color(0xFF2F6B3B),
    soft: const Color(0xFFE4ECDF),
    icon: 'shield-check',
  ),
  'daily': DomainInfo(
    key: 'daily',
    label: 'Daily Life Skills',
    description: 'Managing routines and independent living tasks',
    color: const Color(0xFF4A4A4A),
    soft: const Color(0xFFE4E2DC),
    icon: 'key-round',
  ),
  'communication': DomainInfo(
    key: 'communication',
    label: 'Communication Skills',
    description: 'Expressing needs and understanding others clearly',
    color: const Color(0xFF2A6873),
    soft: const Color(0xFFD8E6E8),
    icon: 'message-circle',
  ),
  'social': DomainInfo(
    key: 'social',
    label: 'Social Understanding',
    description: 'Reading social situations and responding appropriately',
    color: const Color(0xFFA85822),
    soft: const Color(0xFFF1E1D2),
    icon: 'map-pin',
  ),
  'coping': DomainInfo(
    key: 'coping',
    label: 'Coping & Stress Management',
    description: 'Staying regulated when things feel hard',
    color: const Color(0xFF6E0D25),
    soft: const Color(0xFFEFD9DE),
    icon: 'wind',
  ),
  'selfadvocacy': DomainInfo(
    key: 'selfadvocacy',
    label: 'Self-Advocacy & Confidence',
    description: 'Knowing your needs and speaking up for yourself',
    color: const Color(0xFF9C7314),
    soft: const Color(0xFFF1E6CB),
    icon: 'compass',
  ),
};

// ─── Card Data ────────────────────────────────────────────────────────────────
final List<SBICard> allEnhancedCards = [

  // ── WORKPLACE ──────────────────────────────────────────────────────────────

  SBICard(
    id: 'WK-01', domain: 'workplace', word: 'Reliable', level: 2,
    affirmation: 'I can be relied on.',
    icon: 'check-circle',
    definition: 'Reliable means people can count on me to do what I said I would do.',
    practice: 'Complete one task you agreed to do today without being reminded.',
    reflection: 'Was there a time today when someone counted on you? How did it feel?',
    generalizationChallenge: 'Complete one task you agreed to do today.',
    looksLike: ['I follow directions', 'I finish my task', 'I return from break on time', 'I ask for help if I need it'],
    notLike: ['Saying yes then not doing it', 'Leaving tasks unfinished', 'Not showing up when expected'],
    teachItPrompts: ['What does reliable mean?', 'When would you need to be reliable?', 'Show me what reliable looks like at work.', 'Tell me about a time someone was reliable for you.'],
    promptingSupports: ['Model completing a task and returning on time', 'Offer two choices: finish now or ask for help', 'Use a visual timer', 'Practice again together'],
    imageUrl: domainSceneImages['workplace'],
    scenario: Scenario(
      prompt: 'Your supervisor asks you to finish stacking the shelf before your break. You really want to stop. What is the reliable choice?',
      choices: [
        ScenarioChoice(text: 'Stop working and take your break early', isCorrect: false, feedback: 'Try again. Leaving early makes it harder for others to count on you.'),
        ScenarioChoice(text: 'Finish the task, then take your break', isCorrect: true, feedback: 'Nice choice. Finishing the task shows you are reliable.'),
        ScenarioChoice(text: 'Ask your supervisor if you can finish after your break', isCorrect: true, feedback: 'Great thinking. Asking is a reliable and professional choice.'),
        ScenarioChoice(text: 'Walk away without saying anything', isCorrect: false, feedback: 'Try again. Walking away without communicating can cause problems.'),
      ],
    ),
  ),

  SBICard(
    id: 'WK-02', domain: 'workplace', word: 'Professional', level: 2,
    affirmation: 'I can act professionally.',
    icon: 'briefcase',
    definition: 'Professional means I use safe, respectful behavior in work settings.',
    practice: 'Practice using a calm voice and respectful words during a work task today.',
    reflection: 'What does professional behavior look like in a place you work or visit?',
    generalizationChallenge: 'Use respectful words with every coworker or supervisor today.',
    looksLike: ['I use respectful words', 'I keep my body calm', 'I follow workplace rules', 'I dress appropriately'],
    notLike: ['Using loud or rude language', 'Ignoring workplace rules', 'Making others feel uncomfortable'],
    teachItPrompts: ['What makes someone look professional?', 'How do you act at a job vs. at home?', 'Show me professional body language.', 'What would happen if someone was not professional at work?'],
    promptingSupports: ['Model professional greetings', 'Use role-play with two choices', 'Show visual examples of professional vs. unprofessional behavior', 'Practice with real workplace scenarios'],
    imageUrl: domainSceneImages['workplace'],
    scenario: Scenario(
      prompt: 'A coworker says something that bothers you. What is the professional choice?',
      choices: [
        ScenarioChoice(text: 'Yell at them in front of everyone', isCorrect: false, feedback: 'Try again. Yelling at work can cause bigger problems.'),
        ScenarioChoice(text: 'Take a breath and talk calmly later', isCorrect: true, feedback: 'Great choice. Staying calm is a professional response.'),
        ScenarioChoice(text: 'Tell a supervisor if it keeps happening', isCorrect: true, feedback: 'Nice thinking. Using the right support is professional.'),
        ScenarioChoice(text: 'Ignore all your tasks for the rest of the day', isCorrect: false, feedback: 'Try again. Stopping work can affect your whole team.'),
      ],
    ),
  ),

  SBICard(
    id: 'WK-03', domain: 'workplace', word: 'Responsible', level: 1,
    affirmation: 'I can take care of what I need to do.',
    icon: 'clipboard',
    definition: 'Responsible means I complete expected tasks and follow through.',
    practice: 'Name three things you are responsible for today and check them off.',
    reflection: 'What is one responsibility you are proud of?',
    generalizationChallenge: 'Clean up your workspace at the end of your shift without being reminded.',
    looksLike: ['I clean up after myself', 'I bring what I need', 'I finish my work', 'I tell someone if there is a problem'],
    notLike: ['Leaving messes for others', 'Forgetting materials', 'Blaming others when something goes wrong'],
    teachItPrompts: ['What are you responsible for at school or work?', 'What happens when someone is not responsible?', 'Show me what responsible clean-up looks like.', 'What is one responsibility you can practice today?'],
    promptingSupports: ['Use a visual checklist', 'Model task completion step by step', 'Offer gentle reminders, then fade them', 'Celebrate task completion'],
    imageUrl: domainSceneImages['workplace'],
    scenario: Scenario(
      prompt: 'You accidentally spill something at your workstation. What is the responsible choice?',
      choices: [
        ScenarioChoice(text: 'Walk away and hope no one notices', isCorrect: false, feedback: 'Try again. Leaving a spill can be unsafe for others.'),
        ScenarioChoice(text: 'Clean it up or tell someone who can help', isCorrect: true, feedback: 'Great choice. Taking care of the problem is responsible.'),
        ScenarioChoice(text: 'Blame someone else for the spill', isCorrect: false, feedback: 'Try again. Taking responsibility means owning what happened.'),
        ScenarioChoice(text: 'Ask for help cleaning it up safely', isCorrect: true, feedback: 'Nice choice. Asking for help when needed is responsible.'),
      ],
    ),
  ),

  // ── RELATIONSHIP ───────────────────────────────────────────────────────────

  SBICard(
    id: 'RL-01', domain: 'relationship', word: 'Friendly', level: 1,
    affirmation: 'I can be friendly without touching.',
    icon: 'smile',
    definition: 'Friendly means I show kindness while respecting personal space.',
    practice: 'Greet one person today with a smile, a wave, or kind words.',
    reflection: 'How did it feel when you showed friendliness to someone today?',
    generalizationChallenge: 'Say hello to a coworker or neighbor using friendly words this week.',
    looksLike: ['I wave or smile', 'I say hi or good morning', 'I ask before hugging', 'I use kind words'],
    notLike: ['Touching without asking', 'Ignoring people who say hello', 'Using rude greetings'],
    teachItPrompts: ['What does friendly look like without touching?', 'How can you greet someone in a safe way?', 'Show me a friendly greeting.', 'When would a wave be better than a hug?'],
    promptingSupports: ['Model safe greetings', 'Practice with two greeting options', 'Use visual cue cards for greetings', 'Role-play community scenarios'],
    imageUrl: domainSceneImages['relationship'],
    scenario: Scenario(
      prompt: 'You see a classmate you like and want to show them you are happy to see them. What is a friendly and safe choice?',
      choices: [
        ScenarioChoice(text: 'Run and hug them tightly', isCorrect: false, feedback: 'Try again. Hugging without asking can make others uncomfortable.'),
        ScenarioChoice(text: 'Wave and say "Hi, good to see you!"', isCorrect: true, feedback: 'Great choice. A wave and kind words is friendly and safe.'),
        ScenarioChoice(text: 'Ignore them and walk away', isCorrect: false, feedback: 'Try again. Ignoring can feel unfriendly to others.'),
        ScenarioChoice(text: 'Give a thumbs up and smile', isCorrect: true, feedback: 'Nice choice. A thumbs up is friendly and respects personal space.'),
      ],
    ),
  ),

  SBICard(
    id: 'RL-02', domain: 'relationship', word: 'Patient', level: 2,
    affirmation: 'I can wait calmly.',
    icon: 'clock',
    definition: 'Patient means I can wait without rushing, grabbing, or interrupting.',
    practice: 'Practice waiting for 3 minutes without interrupting during an activity.',
    reflection: 'When is waiting hardest for you? What helps?',
    generalizationChallenge: 'Wait your turn in line today without speaking or grabbing.',
    looksLike: ['I wait my turn', 'I keep my hands to myself', 'I use calm words', 'I find something to do while I wait'],
    notLike: ['Interrupting others', 'Grabbing things from others', 'Saying "now, now, now"'],
    teachItPrompts: ['What does patient look like in a waiting room?', 'How do you keep yourself busy while waiting?', 'Show me patient body language.', 'What helps you wait calmly?'],
    promptingSupports: ['Use a visual timer to show wait time', 'Offer a fidget or calm activity during waiting', 'Practice short waits and build up', 'Praise calm waiting behavior'],
    imageUrl: domainSceneImages['relationship'],
    scenario: Scenario(
      prompt: 'You are waiting to use the computer and it is taking a long time. What is the patient choice?',
      choices: [
        ScenarioChoice(text: 'Push the person off the computer', isCorrect: false, feedback: 'Try again. Pushing can hurt others and is not safe.'),
        ScenarioChoice(text: 'Keep asking "Is it my turn yet?" over and over', isCorrect: false, feedback: 'Try again. Repeating questions can bother others. Try waiting quietly.'),
        ScenarioChoice(text: 'Find something else to do while you wait', isCorrect: true, feedback: 'Great choice. Keeping busy makes waiting easier.'),
        ScenarioChoice(text: 'Ask politely once when it might be your turn', isCorrect: true, feedback: 'Nice choice. Asking once politely is a calm and patient move.'),
      ],
    ),
  ),

  SBICard(
    id: 'RL-03', domain: 'relationship', word: 'Respectful', level: 2,
    affirmation: 'I can show respect to others.',
    icon: 'heart',
    definition: 'Respectful means I treat people in a way that makes them feel valued and safe.',
    practice: 'Use one respectful word or action with someone today.',
    reflection: 'How does it feel when someone shows you respect?',
    generalizationChallenge: 'Use kind words when someone tells you "not right now."',
    looksLike: ['I listen when others speak', 'I use kind words', 'I follow directions', 'I wait for my turn'],
    notLike: ['Talking over others', 'Using rude words', 'Ignoring directions', 'Making fun of others'],
    teachItPrompts: ['What does respect look like at home? At school? At work?', 'Show me one respectful thing you can do right now.', 'How do you show respect without words?', 'What does disrespect feel like?'],
    promptingSupports: ['Model respectful language', 'Role-play "not right now" scenarios', 'Use visual cues for respectful body language', 'Practice daily with real interactions'],
    imageUrl: domainSceneImages['relationship'],
    scenario: Scenario(
      prompt: 'Someone tells you "not right now." What is a respectful choice?',
      choices: [
        ScenarioChoice(text: 'Yell at them', isCorrect: false, feedback: 'Try again. Yelling can make the problem bigger.'),
        ScenarioChoice(text: 'Use kind words and say "okay, I will wait"', isCorrect: true, feedback: 'Nice choice. That is respectful and calm.'),
        ScenarioChoice(text: 'Walk away safely and find something else to do', isCorrect: true, feedback: 'Great choice. Walking away calmly shows self-control and respect.'),
        ScenarioChoice(text: 'Throw something nearby', isCorrect: false, feedback: 'Try again. Throwing things is not safe or respectful.'),
      ],
    ),
  ),

  // ── CHARACTER ──────────────────────────────────────────────────────────────

  SBICard(
    id: 'CH-01', domain: 'character', word: 'Honest', level: 2,
    affirmation: 'I can tell the truth.',
    icon: 'shield-check',
    definition: 'Honest means I tell the truth even when it is hard.',
    practice: 'Tell the truth about one small thing today, even if it feels uncomfortable.',
    reflection: 'Why is honesty important in relationships and at work?',
    generalizationChallenge: 'If you make a mistake today, tell someone honestly instead of hiding it.',
    looksLike: ['I tell the truth', 'I admit when I make a mistake', 'I do not hide problems', 'I follow through on what I say'],
    notLike: ['Making up stories', 'Hiding mistakes', 'Blaming others for things I did', 'Saying one thing and doing another'],
    teachItPrompts: ['What does honest mean?', 'Why is it hard to be honest sometimes?', 'Show me what honest looks like.', 'What happens when someone is not honest?'],
    promptingSupports: ['Practice honest role-plays in safe settings', 'Praise honesty immediately when it happens', 'Discuss consequences of honesty vs. dishonesty calmly', 'Model honest mistake-making yourself'],
    imageUrl: domainSceneImages['character'],
    scenario: Scenario(
      prompt: 'You broke something by accident at school. What is the honest choice?',
      choices: [
        ScenarioChoice(text: 'Hide it and pretend it did not happen', isCorrect: false, feedback: 'Try again. Hiding the problem usually makes things harder later.'),
        ScenarioChoice(text: 'Tell a trusted adult what happened', isCorrect: true, feedback: 'Great choice. Being honest helps solve the problem faster.'),
        ScenarioChoice(text: 'Blame someone else', isCorrect: false, feedback: 'Try again. Blaming others when you made the mistake is not honest.'),
        ScenarioChoice(text: 'Say "I accidentally broke this. Can we fix it?"', isCorrect: true, feedback: 'Nice choice. Owning your mistake and asking for help is honest and brave.'),
      ],
    ),
  ),

  SBICard(
    id: 'CH-02', domain: 'character', word: 'Kind', level: 1,
    affirmation: 'I can show kindness to others.',
    icon: 'gift',
    definition: 'Kind means treating people in a way that is warm and helpful.',
    practice: 'Do one kind thing for someone today without being asked.',
    reflection: 'How did it feel to do something kind?',
    generalizationChallenge: 'Help someone with a task at school, work, or home without being asked.',
    looksLike: ['Saying please and thank you', 'Helping someone who needs it', 'Smiling at others', 'Using gentle words'],
    notLike: ['Name-calling', 'Teasing', 'Pushing or grabbing', 'Leaving someone out on purpose'],
    teachItPrompts: ['What is one kind thing you can do right now?', 'How do you know when someone needs kindness?', 'Show me a kind action without any words.', 'What is the difference between kind and unkind?'],
    promptingSupports: ['Model random acts of kindness', 'Create a kindness challenge list', 'Use visual examples of kind vs. unkind', 'Celebrate kind moments immediately'],
    imageUrl: domainSceneImages['character'],
    scenario: Scenario(
      prompt: 'You notice a classmate dropped all their papers. What is the kind choice?',
      choices: [
        ScenarioChoice(text: 'Laugh and walk past them', isCorrect: false, feedback: 'Try again. Laughing at someone\'s problem is unkind.'),
        ScenarioChoice(text: 'Help pick up the papers', isCorrect: true, feedback: 'Great choice. Helping someone in need is kind.'),
        ScenarioChoice(text: 'Ask if they need help', isCorrect: true, feedback: 'Nice choice. Checking in before helping shows respect and kindness.'),
        ScenarioChoice(text: 'Ignore it because it is not your problem', isCorrect: false, feedback: 'Try again. Kindness means noticing others even when we are busy.'),
      ],
    ),
  ),

  // ── COPING ─────────────────────────────────────────────────────────────────

  SBICard(
    id: 'CP-01', domain: 'coping', word: 'Calm', level: 1,
    affirmation: 'I can stay calm and try again.',
    icon: 'wind',
    definition: 'Calm means my body and voice are safe enough to keep going.',
    practice: 'Practice one calming strategy right now: take 3 slow breaths.',
    reflection: 'What makes it hard to stay calm? What helps your body feel safe?',
    generalizationChallenge: 'Use one coping strategy before asking again when something feels hard.',
    looksLike: ['I breathe slowly', 'I ask for a break', 'I use my coping tools', 'I lower my voice'],
    notLike: ['Yelling or screaming', 'Throwing things', 'Running away unsafely', 'Hitting or pushing'],
    teachItPrompts: ['What does calm feel like in your body?', 'What is one thing that helps you feel calm?', 'Show me calm body language.', 'What can you do when your body feels upset?'],
    promptingSupports: ['Use a calm-down kit with sensory tools', 'Post a visual coping menu nearby', 'Practice calm strategies before stressful moments', 'Offer a break before behavior escalates'],
    imageUrl: domainSceneImages['coping'],
    scenario: Scenario(
      prompt: 'Something does not go the way you expected and you feel your body getting upset. What is a calm choice?',
      choices: [
        ScenarioChoice(text: 'Yell until someone fixes it', isCorrect: false, feedback: 'Try again. Yelling can make the situation feel more stressful.'),
        ScenarioChoice(text: 'Take 3 slow breaths', isCorrect: true, feedback: 'Great choice. Breathing helps your body reset and feel calmer.'),
        ScenarioChoice(text: 'Ask for a short break', isCorrect: true, feedback: 'Nice choice. Taking a break gives your brain time to settle.'),
        ScenarioChoice(text: 'Throw something nearby', isCorrect: false, feedback: 'Try again. Throwing things can hurt others and is not a safe choice.'),
      ],
    ),
  ),

  SBICard(
    id: 'CP-02', domain: 'coping', word: 'Flexible', level: 2,
    affirmation: 'I can try a different way.',
    icon: 'refresh',
    definition: 'Flexible means I can handle a change or try another option.',
    practice: 'When something changes today, say "okay" and try the new plan.',
    reflection: 'What is hardest about changes for you? What helps?',
    generalizationChallenge: 'Try a different way when the first plan changes today.',
    looksLike: ['I accept a new plan', 'I choose another option', 'I try again', 'I ask for help with the change'],
    notLike: ['Refusing all changes', 'Shutting down when plans shift', 'Insisting on one way only'],
    teachItPrompts: ['What does flexible mean?', 'What happens in your body when something changes?', 'Show me flexible thinking.', 'What helps you handle changes better?'],
    promptingSupports: ['Preview changes before they happen', 'Use a visual schedule that shows changes', 'Offer 2 acceptable options during a change', 'Praise any flexible response immediately'],
    imageUrl: domainSceneImages['coping'],
    scenario: Scenario(
      prompt: 'You planned to go outside but it is raining. What is a flexible choice?',
      choices: [
        ScenarioChoice(text: 'Refuse to do anything else all day', isCorrect: false, feedback: 'Try again. Refusing all options keeps you stuck and makes the day harder.'),
        ScenarioChoice(text: 'Choose an indoor activity you enjoy', isCorrect: true, feedback: 'Great choice. Picking something else shows flexible thinking.'),
        ScenarioChoice(text: 'Ask if there is another time to go outside', isCorrect: true, feedback: 'Nice choice. Asking for another option is a great flexible response.'),
        ScenarioChoice(text: 'Yell that it is not fair', isCorrect: false, feedback: 'Try again. The weather is out of anyone\'s control. Flexible thinking can help here.'),
      ],
    ),
  ),

  // ── SELF-ADVOCACY ──────────────────────────────────────────────────────────

  SBICard(
    id: 'SA-01', domain: 'selfadvocacy', word: 'Confident', level: 2,
    affirmation: 'I can show up with confidence.',
    icon: 'star',
    definition: 'Confident means I try even when something feels hard.',
    practice: 'Try one thing today that feels a little hard without giving up.',
    reflection: 'What is one thing you feel confident about? What are you working on?',
    generalizationChallenge: 'Introduce yourself to someone new using a clear, confident voice.',
    looksLike: ['I ask questions', 'I try the task', 'I use a clear voice', 'I accept help when I need it'],
    notLike: ['Refusing to try', 'Saying "I can\'t" before starting', 'Hiding or avoiding'],
    teachItPrompts: ['What does confident body language look like?', 'What is something you felt confident about?', 'Show me a confident voice.', 'How do you build confidence?'],
    promptingSupports: ['Start with highly preferred tasks to build success', 'Use "I can try" as a prompt', 'Celebrate effort, not just outcomes', 'Model confidence in everyday interactions'],
    imageUrl: domainSceneImages['selfadvocacy'],
    scenario: Scenario(
      prompt: 'You are asked to try a new task you have never done before. What is the confident choice?',
      choices: [
        ScenarioChoice(text: 'Say "I can\'t" and walk away', isCorrect: false, feedback: 'Try again. Saying "I can\'t" before trying closes the door on learning.'),
        ScenarioChoice(text: 'Say "I will try" and give it a go', isCorrect: true, feedback: 'Great choice. Trying is the first step to confidence.'),
        ScenarioChoice(text: 'Ask for help to get started', isCorrect: true, feedback: 'Nice choice. Asking for support and then trying shows real confidence.'),
        ScenarioChoice(text: 'Wait for someone else to do it for you', isCorrect: false, feedback: 'Try again. Waiting for others keeps you from building your own skills.'),
      ],
    ),
  ),

  SBICard(
    id: 'SA-02', domain: 'selfadvocacy', word: 'Help-Seeking', level: 1,
    affirmation: 'I can ask for help.',
    icon: 'hand',
    definition: 'Help-seeking means I tell someone when I need support.',
    practice: 'Ask for help with one thing today instead of struggling alone.',
    reflection: 'Who are the trusted people in your life you can ask for help?',
    generalizationChallenge: 'Ask a trusted adult for help with something this week.',
    looksLike: ['I say "help please"', 'I show the problem', 'I ask a trusted person', 'I wait for a response'],
    notLike: ['Struggling silently until frustrated', 'Acting out instead of asking', 'Asking anyone around instead of a trusted person'],
    teachItPrompts: ['Who are the safe people you can ask for help?', 'Show me how you ask for help.', 'What does it feel like to need help?', 'Why is asking for help a strength, not a weakness?'],
    promptingSupports: ['Post a visual list of trusted helpers', 'Practice "help please" in low-stress moments', 'Pair with a visual or AAC support if needed', 'Praise every help-seeking attempt'],
    imageUrl: domainSceneImages['selfadvocacy'],
    scenario: Scenario(
      prompt: 'You are confused about how to do a task at work. What is the best choice?',
      choices: [
        ScenarioChoice(text: 'Pretend you understand and do it wrong', isCorrect: false, feedback: 'Try again. Pretending can lead to bigger problems later.'),
        ScenarioChoice(text: 'Ask your supervisor to explain again', isCorrect: true, feedback: 'Great choice. Asking questions is a sign of strength and responsibility.'),
        ScenarioChoice(text: 'Stop working and not tell anyone', isCorrect: false, feedback: 'Try again. Stopping without telling anyone is not helpful for you or your team.'),
        ScenarioChoice(text: 'Say "I need help with this part, can you show me?"', isCorrect: true, feedback: 'Nice choice. That is a clear and confident way to ask for help.'),
      ],
    ),
  ),

  // ── COMMUNICATION ──────────────────────────────────────────────────────────

  SBICard(
    id: 'CM-01', domain: 'communication', word: 'Clear', level: 2,
    affirmation: 'I can say what I need.',
    icon: 'message-circle',
    definition: 'Clear means I express my needs so others can understand me.',
    practice: 'Practice saying one thing you need clearly and directly today.',
    reflection: 'What makes communicating clearly hard sometimes?',
    generalizationChallenge: 'Tell someone what you need today using complete words or a communication tool.',
    looksLike: ['I use words or tools to express my needs', 'I speak at a volume others can hear', 'I make eye contact when I am ready', 'I ask again if not understood'],
    notLike: ['Assuming people know what I mean', 'Using behaviors instead of words', 'Giving up after one try'],
    teachItPrompts: ['Show me how you ask for something clearly.', 'What helps you communicate better?', 'What do you do when someone does not understand you?', 'Practice asking for one thing clearly right now.'],
    promptingSupports: ['Use sentence starters or scripts', 'Allow AAC or visual supports', 'Practice in low-stress environments first', 'Model clear communication yourself'],
    imageUrl: domainSceneImages['communication'],
    scenario: Scenario(
      prompt: 'You need a break but no one has offered one. What is the clearest choice?',
      choices: [
        ScenarioChoice(text: 'Hope someone notices you need a break', isCorrect: false, feedback: 'Try again. Others may not notice. Asking directly gets you what you need.'),
        ScenarioChoice(text: 'Say or show "I need a break please"', isCorrect: true, feedback: 'Great choice. Asking clearly is the most effective way to get support.'),
        ScenarioChoice(text: 'Act out until someone gives you a break', isCorrect: false, feedback: 'Try again. Using behavior instead of words can cause problems.'),
        ScenarioChoice(text: 'Use your break card or AAC device to ask', isCorrect: true, feedback: 'Nice choice. Using any communication tool is a clear and strong move.'),
      ],
    ),
  ),

  // ── SOCIAL UNDERSTANDING ───────────────────────────────────────────────────

  SBICard(
    id: 'SO-01', domain: 'social', word: 'Aware', level: 2,
    affirmation: 'I can notice what is happening around me.',
    icon: 'eye',
    definition: 'Aware means I pay attention to people and situations around me.',
    practice: 'Look around your environment and name 3 things you notice about the people nearby.',
    reflection: 'How does being aware of others help you make better choices?',
    generalizationChallenge: 'Notice how someone is feeling today and respond to what you see.',
    looksLike: ['I look around before acting', 'I notice how others are feeling', 'I adjust my behavior based on the situation', 'I read the room'],
    notLike: ['Only thinking about myself', 'Ignoring cues from others', 'Acting without thinking about the situation'],
    teachItPrompts: ['What do you notice about the people around you right now?', 'How can you tell if someone is upset?', 'Show me what "reading the room" looks like.', 'What is one time your awareness helped you?'],
    promptingSupports: ['Use emotion picture cards', 'Practice noticing feelings in video clips', 'Narrate social situations out loud', 'Use check-in questions before activities'],
    imageUrl: domainSceneImages['social'],
    scenario: Scenario(
      prompt: 'Your teacher looks stressed and busy. You want to ask a question. What is an aware choice?',
      choices: [
        ScenarioChoice(text: 'Interrupt immediately with your question', isCorrect: false, feedback: 'Try again. Interrupting a stressed person can make things harder.'),
        ScenarioChoice(text: 'Wait for a calm moment to ask your question', isCorrect: true, feedback: 'Great choice. Reading the situation and waiting shows social awareness.'),
        ScenarioChoice(text: 'Ask a classmate or check if your question can wait', isCorrect: true, feedback: 'Nice thinking. Finding another option when someone is busy is a great skill.'),
        ScenarioChoice(text: 'Give up on asking anything', isCorrect: false, feedback: 'Try again. Your question matters. Find the right moment to ask it.'),
      ],
    ),
  ),

  // ── DAILY LIFE ─────────────────────────────────────────────────────────────

  SBICard(
    id: 'DL-01', domain: 'daily', word: 'Organized', level: 2,
    affirmation: 'I can keep my things in order.',
    icon: 'layout',
    definition: 'Organized means I keep my space and belongings in a way that helps me function.',
    practice: 'Organize one area of your space today — your bag, desk, or locker.',
    reflection: 'What happens when your space is disorganized? How does it affect you?',
    generalizationChallenge: 'Pack your bag or prepare your materials for tomorrow before you go to bed.',
    looksLike: ['I put things in their place', 'I have a system for my materials', 'I can find what I need', 'I prepare ahead of time'],
    notLike: ['Losing things often', 'Leaving materials out everywhere', 'Never being able to find what is needed'],
    teachItPrompts: ['Where does your backpack go when you arrive?', 'Show me how you organize your workspace.', 'What happens when things are not organized?', 'What system helps you stay organized?'],
    promptingSupports: ['Use labeled bins or color-coded folders', 'Build end-of-day organization into a routine', 'Use visual organization schedules', 'Celebrate when things are in order'],
    imageUrl: domainSceneImages['daily'],
    scenario: Scenario(
      prompt: 'You cannot find your work materials and your task is about to start. What is the organized choice?',
      choices: [
        ScenarioChoice(text: 'Panic and do nothing', isCorrect: false, feedback: 'Try again. Panicking does not solve the problem. Take a breath and act.'),
        ScenarioChoice(text: 'Ask for a moment to find your things and look systematically', isCorrect: true, feedback: 'Good choice. Staying calm and being systematic helps you find what you need.'),
        ScenarioChoice(text: 'Ask a peer or instructor if they have a spare', isCorrect: true, feedback: 'Nice thinking. Asking for support in a calm way is organized problem-solving.'),
        ScenarioChoice(text: 'Skip the task because you are not ready', isCorrect: false, feedback: 'Try again. Skipping work because of disorganization can have bigger consequences.'),
      ],
    ),
  ),
];

// ─── Today's Card Picker (cycles by day index) ───────────────────────────────
SBICard getTodaysCard() {
  final dayIndex = DateTime.now().difference(DateTime(2025, 1, 1)).inDays;
  return allEnhancedCards[dayIndex % allEnhancedCards.length];
}
