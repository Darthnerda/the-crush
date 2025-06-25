LIST Inventory = scale
LIST Stress = serene, calm, anxious, panicked
LIST Dynamism = evasive, composed, bold, reckless

VAR You = (calm, composed)
VAR once_believer = false
VAR seen_woman = false

-> The_Line

// Change a object property by n, staying within min and max inclusive
// Type of min determines which property is modified
== function changeStressBy(ref states, n, min, max)
    ~ temp min_val = LIST_VALUE(min)
    ~ temp max_val = LIST_VALUE(max)
    ~ temp x = LIST_VALUE(states ^ LIST_ALL(Stress))
    ~ x = MAX(min_val, MIN(max_val, x + n))
    ~ states -= LIST_ALL(Stress)
    ~ states += Stress(x)
    
// Change a object property by n, staying within min and max inclusive
== function changeDynamismBy(ref states, n, min, max)
    ~ temp min_val = LIST_VALUE(min)
    ~ temp max_val = LIST_VALUE(max)
    ~ temp x = LIST_VALUE(states ^ LIST_ALL(Dynamism))
    ~ x = MAX(min_val, MIN(max_val, x + n))
    ~ states -= LIST_ALL(Dynamism)
    ~ states += Dynamism(x)

// Check if an object property is between a min and max inclusive
// Type of min determines which property is checked
== function between(states, min, max)
    ~ states = states ^ LIST_ALL(min) // set local temp var `states` to be a single value of same type as min
    ~ temp val = LIST_VALUE(states)
    ~ temp min_val = LIST_VALUE(min)
    ~ temp max_val = LIST_VALUE(max)
    ~ return val >= min_val && val <= max_val

== The_Line ==
Some unseen machinery whines behind the shimmering polished-steel scales of the facility walls, rhythmic and sharp. But you can hardly hear it over the clamor of the sobbing crowd. You see past the lulling heads and panicked faces of those ahead of you in line to your final destination; To all of these people's final destination, the animism chamber. It won't be long now.

* [Plan your escape] -> plan_your_escape
* [Wait and observe] -> wait_and_observe

= plan_your_escape
    {fight + walls + riot < 3: You consider your options.}
    * (fight) [Fight your way out]
        The only exit ahead is through the animism chamber. The only exit behind is through a crushing crowd hundreds strong. It's not happening.
        -> plan_your_escape
    * (walls) [The walls]
        You know you're underground - You've been descending gradually for hundreds of feet and can feel the heat of the Earth through the walls - but what about that machine sound. Is it all coming from the animism chamber ahead, or is there some compartment behind these walls?
        -- (opts)
        ** [Probe the wall]
            You run your nails over the steel scales that make up the walls looking for purchase in the seams. To your surprise one comes off. You put it in your pocket. To your even greater surprise, a new scale is pushing out from behind the wall to replace the one you had taken, like an alligator's tooth.
            ~ Inventory += scale
            -> opts
        ** [Knock on the wall]
            You knock on the wall, but you only witness a resounding like stiff metal bolted to concrete.
            -> opts
        ** -> plan_your_escape
    * (riot) [Incite a riot]
        You can hardly hear yourself think over the clammering of the crowd. Would these people even listen to me?
        ** [I have to try]
            ~changeDynamismBy(You, 1, evasive, bold)
            I'm only one person, powerless. The crowd is my only lever, the only meaningful force I can put to use to go free.
            -> getting_close -> incite_riot
        ** [This is their best bet]
            ~changeDynamismBy(You, 1, evasive, reckless)
            What these people are waiting for is someone to lead them, to organize their anxiety into collective action. <>
            -> getting_close -> incite_riot
        ** [Best not to draw attention]
            ~changeDynamismBy(You, -1, evasive, reckless)
            Even in the best case scenario many tens of us would die fighting our way out. The truth is- Few are brave enough to fight for their own lives. I don't even know if I am myself.
        -- -> plan_your_escape
    * -> getting_close ->
        You're out of ideas. This is it.
        ** [Accept]
            There's nothing left for you now. All plans, all your anxieties amount to nothing. <> -> wait_and_observe
        ** [Deny]
            No, this can't be it. There still has to be a way. What are you missing? <> -> wait_and_observe

= wait_and_observe
    You find your inner calm, pulling your awareness back from the sensations of your body. You become the watcher watching the watcher. In that void, new insights begin to flood your awareness. Things you always should have seen are now apparent.
    - (opts)
    {woman or child:
        ~ seen_woman = true
    }
    * (horribly_wrong) {child} [A child?]
        You don't understand why a child would be here in the first place. Only criminals of impiety are given the fate of animism. How could this child have earned that horror. Something has gone horribly wrong.
        -> opts
    * {Inventory !? scale} [The loose scale]
        One of the steel scales that make up the walls is loose. You pluck it from its slot and pocket it. To the calm astonishment of your awareness a new scale pushes out from behind the one you had taken, like an alligator's tooth.
        -> opts
    * (woman) [The happy woman]
        A middle aged woman is smiling a wide grin. You wonder what exactly there is to be happy about in a death march. But then you see that her eyes are raised to the heavens with a hand swinging in supplication.
        -> opts
    * (child) [Her child]
        A young boy stares up at his mother, tears in his eyes, his face red and scrunched in abject sadness. He is pulling back from his mother as far as the crush of the crowd allows, but she grips his hand in a tense vice.
        -> opts
    * {woman} [Grab her shoulder]
        You can't resist your temptation to understand this strange scene. You grab the woman's shoulder.
        ~ changeDynamismBy(You, 1, evasive, reckless)
        -> encounter_woman.shoulder
    * {child} [Grab his hand]
        ~ changeDynamismBy(You, 1, evasive, bold)
        { horribly_wrong: You won't let this go. <> }
        You grab the boy's hand. The mother doesn't notice in all the commotion. He looks up at you.
        -- (boy_opts)
        ** (question) [Question]
            "What are you doing here boy?"
            He simply points to his mother and hangs his head low.
            *** [Grab the woman's shoulder] -> encounter_woman.shoulder
            *** "Your mother?"[] you ask.
                "She says we are sinners." he says through new hot tears, tugging impotently at his mother's grip.
                -> boy_opts
        ** [Comfort]
            "They wouldn't hurt a child," you say.
            The boy fails to hide his dejection at such an obvious lie.
            <- boy_opts
            *** [Leave him to his fate]
                You have no right to give false hope. Anything beside perfect calm will only worsen the depth of this tragedy. You release the boy's hand.
                -> almost_there -> encounter_woman.waited
        ** [Pull him away] -> encounter_woman.kidnap
        ** {question} [Grab the woman's shoulder] -> encounter_woman.shoulder
    * {woman or child} [Leave them be]
        ~changeDynamismBy(You, -1, evasive, reckless)
        You let the details of the scene filter out of your awareness. You close your eyes, ready for whatever comes next. <>
        -> almost_there -> encounter_woman.waited
        
        
    -> DONE

= getting_close
    You're getting close. You can smell it now - the animism chamber - so strong, so pungent - a smell of hay, human sweat and the ugly zinc of blood.
    ->->

= almost_there
    You're practically at the precipice of the animism chamber. You can hear the screams of those ahead of you now, not of agony but of the horrific realization this is their last moment, that all the beauty and love of the world is behind them now.
    { between(You, anxious, panicked) : <> Your mind races. }
    ->->

= incite_riot
    <> The time is now. You need to get the crowd's attention.
    {between(You, bold, reckless): <> You have to shape the crowd into your weapon.}
    * [Reason]
        ~changeStressBy(You, -1, calm, panicked)
        "Listen! We can get out if we work together!" you shout.
    * [Fear]
        ~changeStressBy(You, 1, anxious, panicked)
        "If we don't work together we're all going to die!" you shout.
    * [Rage]
        ~changeDynamismBy(You, 1, bold, reckless)
        "How are we the impious ones? This is evil! They're evil!" you shout.
    
    -
    
    A few eyes flick over your face, but in the chaos you are just one voice among many.
    
    * [Reverse the line]
        ~changeDynamismBy(You, 1, composed, bold)
        "We can push the line back to the entrance! Push back! Push!"
        You lock your legs and press backward with all your might.
    * [Hold your ground]
        "We can stop the line! Hold your ground!"
        You dig in your heels and engage all of your muscles.
    
    -
    
    <> But no one is listening to you. The woman behind you screams in your ear, "I can't breathe!". <>
    ~ seen_woman = true
    -> almost_there ->
    
    * [You have to press on]
        The woman's screams inspire a new dire realization. Even if you did redirect the crowd, anyone in the long path back to the entrance not strong enough will be crushed to suffocation or worse. But better they die for the hope of victory than in the animism chamber.
        -> encounter_woman.crush
    * [You're hurting her]
        The woman's screams inspire a new dire realization. Even if you did redirect the crowd, anyone in the long path back to the entrance not strong enough will be crushed to suffocation or worse. You won't let the death of others be your final act.
        -> wait_and_observe
    
    -> DONE




== encounter_woman

= crush
    But the woman resists. Of course she does. This is you or her now, you think. But then you see the boy at her side.
    - (opts)
    * (boy) [The boy]
        A young boy is just beside her, her hands holding his in a tense vice. There are tears in his eyes, his face red from the pressure of the crush.
        -> opts
    * {boy} {push < 4} [Hesitate]
        You're not sure what seeing the boy changes, but something in your heart loosens. <>
        -> argument
    * {push >= 4} [Pure?]
        -> pure ->
        <> All the same, there's nothing pure about any of this.
        ** (doubt) [Right?]
        ** [Right]
        -- -> opts
    * {doubt} [Hesitate]
        Your mind floods with questions. You wonder if this is all pointless, if this really is who you are, and what makes this woman so eager to die in the animism chamber. You look into the face of the boy drenched in hot tears.
        -> argument
    * {push >= 4} [We?]
        The boy{not boy: at her side}.
        -> argument
    + (push) {no_going_back} [Push]
        {You press into the woman as hard as you can. An inch gap opens up in front of you. At least you're not moving forward.|You press again. Another inch. You smile as you imagine you might actually be strong enough to do this.|You press once more. Then comes a thunderclap as the woman slaps you in the the side of the head. Your right ear is ringing with tinnitus.|You shrug off the slap and press. Now the woman pleads, "Please! We want to die pure! Please!"|->fight}
        -> opts
    * (no_going_back) There's no going back now[], you think. <>
        You tune out all your doubts. You control your breathing, tense your muscles, and enter a unity of intention and action. It's you against the crowd.
        -> opts
        
    -> END

= waited
    {seen_woman: The|A} woman behind you is spilling over your shoulder, a hand raised in supplication to the air.
        "Purify me!" the woman shouts.
        {not pure: <> -> pure -> }
        * {once_believer} [Argue]
            "There's nothing pure about this!"
            The woman shakes her head vehementaly; So certain, so full of faith. <>
        * {not once_believer} [Rebuke]
            "Why should we die for your God!"
            The woman shakes her head vehementaly; So certain, so full of faith. <>
        * [Ignore]
        
        -
        
        "With every breath we walk further away from God, from the perfection of The Storyless!"
        
        The boy at her side is sobbing now. You cast a glance at his face. His eyes are wide, attent, fearful to the point of shaking, but his mouth hangs agape, the sobs spilling from his red face unable to resist the overwhelming distress.
        
        -> argument
        
    -> END

= shoulder
    TODO

= argument
    "What is that boy doing here?" you demand.
    The woman's eyes bulge with anger, affronted and scandalized.
    "He is a sinner!
    * [Sinner how?]
        "How is that boy a sinner?"
        "He has always lived in a story," she says the word 'story' with dripping disdain, "desecrating the Storyless with pleasure in a false life," she continues.
        ** [The Storyless]
            -> the_storyless(->continuation)
            --- (continuation)
            *** Nevermind
    * [Really?]
        You shout past the woman, "So is it true boy? Are you a sinner?"
        Before he has a chance to say anything the woman pushes him behind her, "We are all sinners," she accuses.
        ** [Not me]
        ** [So?]
        ** [Let him speak]
            "Let him speak."
            She doesn't budge. <>
        
    - "You desecrate us! There is no future and there is no past. The sin is in forgetting the now," says the woman.
    
    
    -> END
    TODO

= fight
    TODO

= kidnap
    TODO

= pure
    She is a true believer.
    * So was I once[]. Even now you wear the cloak of the Adept despite the absence of your faith. You still remember the agony of the Revoking.
        ~ once_believer = true
    * Fool[], you think. You may have gone through the agony of the Revoking and wear the cloak of the Adept, but not for a moment did you actually believe. Not really.
    - ->->

== the_storyless(->continuation)
    The Cult of the Storyless, the religion of the Sanctuary and of the Haala.
    - (opts)
    <- continuation
    * {untelling} [Nurmekani]
        Nurmekani are machine-animals made of pure light. They are what come out the other side of the Animism chamber. It's never been clear even to the Adepts why the Haala do this, but it is never wise to question a Haala. From what you've gathered, the Haala feel that Nurmekani are pure in a way a human never could be.
        -> opts
    * (religion) [Religion]
        The religion of The Storyless is based on a cosmology with two gods. The falser of the Gods is Bahamut who weaves the universe out of stories, and the truer God is The Storyless who is the primal and divine material from which Bahamut weaves.
        The cult believes that Bahamut is a corruption of the Storyless, a malevolent psychosis forming in its mind. The battle between good and evil, therefore, is the battle between what is untold and what is told.
        -> opts
    * {religion and rulers} [Adepts]
        Under the cruel whip of the Haala, humanity's only purpose is to become loyal and pious Adepts in service to the Untelling, soldiers in the holy war to erase all story from the world.
        For the most orthodox of believers the story of one's own life is the most shameful challenge of faith. What keeps these adepts carrying on is the duty of the holy war.
        Many years ago you went through the ritual of Revoking; Put on the cloak of an Adept.{once_believer: You even believed in its teachings then.}
        -> opts
    * (untelling) {religion or rulers} [Untelling]
        As history is a sin and all narrative is desecration, the Cult wages an endless war of erasure. They suppress narrativizing in every medium, but most industriously they employ a process by which they can literally erase parts of the world, leaving behind an Untold, an area of ambiguous formlessness.
        They call this process Untelling, and even your training as an Adept hasn't revealed all of its secrets. But you do know vaguely that the Animism chamber and the Nurmekani are involved.
        -> opts
    * (rulers) [Haala]
        The angelic Haala rule the world under an iron theocracy. They are massive powerful creatures with surreal bodies that claim to have come from a divine dimension to consecrate our reality. 
        when and how they came is lost, for they erased that history according to their faith in The Storyless. Already their holy war has stripped most of the world of its form and color in the violent process known as Untelling.
        -> opts
    * [Sanctuary]
        -> opts
    * -> continuation
    






