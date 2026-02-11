 SMODS.Enhancement{
   key = "alien",
   atlas = "ShonenEnhancements",
   pos = { x = 0, y = 0 },
   config = {x_mult = 1.51},
   loc_vars = function(self, info_queue, center)
     return {vars = {self.config.x_mult}}
   end,
   weight = 1,
   calculate = function(self, card, context)
    if context.main_scoring and context.cardarea == G.play then
      local suit = pseudorandom_element(SMODS.Suits, 'alien_suit')
      local rank = pseudorandom_element(SMODS.Ranks, 'alien_rank')

      SMODS.change_base(card, suit.key, rank.key)
    end
   end,
 }