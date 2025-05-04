extends SummonCardResource

# The "Relentless" effect is now handled by the tag check
# in SummonInstance.setup() setting the is_relentless flag,
# which is then used by SummonInstance.perform_turn_activity().
# No specific overrides needed here unless it had other effects.
pass
