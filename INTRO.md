# Welcome, Duelist, to Concentric

Forget swift reflexes, you'll need cunning, foresight, and a well-chosen deck of cards.

Concentric is a deterministic **auto-battler** where you are the *architect* of victory. Once you have built your deck, the battles involve no further choices. They play out automatically based on your strategy, and you are then shown a full replay, a living chronicle of your duel.

---
![Healer Card Art](art/healer_med.webp "Healer") 
### 1. The Deck: Your Grimoire of Strategy

Your journey begins and ends with your deck, which consists of four or fewer cards arranged in a specific order.
* **Summons:** These are creatures you bring to the battlefield. Each has **Power** (⚔, its attack strength) and **HP** (❤, its health). They will fight for you until their HP is 0 or less, at which point they die and go to your Graveyard.
* **Spells:** These are single-use magical effects. They might require a valid "target" to be cast; for example, a spell that boosts a creature can't be cast if you have no creatures. After being cast, they are sent to your Graveyard.

### 2. The Battle: The Unfolding Duel

Each duelist starts with 20 life and 0 mana. Your life cannot go above 20, but your mana can accumulate. The two opponents alternate taking turns, and the flow of a turn is always the same:

1.  **Gain Mana:** The active player gains 1 mana. Some creatures, like the `Wall Of Vines`, can provide extra mana during your turn.
2.  **Casting:** If you have enough mana for the top card of your deck, you will automatically cast it. A creature spell requires a vacant lane to be cast.
3.  **Fighting:** Your creatures attack, from left to right. A creature attacks the opponent's creature in the same lane. If the opposing lane is empty, it attacks the enemy Duelist directly!

### Key Concepts & Keywords

You will encounter many strategic keywords on your journey. Here are some of the most common:

![Wall of Vines Card Art](res://art/wallOfVines_med.webp "Wall of Vines")
* **Arrival:** This effect happens once, as soon as the creature enters the battlefield. For example, `Healer` heals you for 8 HP the moment it arrives.
* **Swift:** Most creatures have "summoning sickness" and cannot attack on the turn they arrive. A `Swift` creature is an exception and can fight immediately.
* **Relentless:** A `Relentless` creature ignores any creature in the opposing lane and always attacks the opponent directly.
* **Undead:** A special creature type. Some spells, like `Unmake`, cannot target `Undead` creatures, making them resilient to certain removal effects.
* **Death:** This effect triggers when a creature's HP drops to 0 or below. The `Recurring Skeleton`, for instance, returns to the bottom of your deck when it dies.

### 3. The Replay

The most crucial part of Concentric is watching the **replay**. Every action is recorded, allowing you to see exactly how your strategy performed.

If no creatures are on the board and neither player can cast a spell, the game might enter a stalemate. After 99 turns, a winner is declared: the player who was "on draw" (went second) wins the game. Analyze these outcomes in the replay to build better decks!

### Further Reading & Resources

For a complete, sortable list of all cards and their abilities with high-quality artwork, please visit the **[Concentric Card Browser](https://niallcardin.com/cardDisplay/CardRulesDisplay.html)**. It is an excellent resource for planning your next winning deck.

You can also see what cards due during deck building of battle replay by hovering on them.