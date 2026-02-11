SMODS.Consumable{
  name = "invasion",
  key = "invasion",
  set = "Planet",
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue+1] = G.P_CENTERS.m_shon_alien
    return {vars = {self.config.add}}
  end,
  config = {add = 2},
  pos = { x = 0, y = 0 },
  atlas = "ShonenConsumables",
  cost = 3,
  unlocked = true,
  discovered = true,
  no_collection = true,
  can_use = function(self, card)
    return true
  end,
  use = function(self, card, area, copier)
    for i = 1, self.config.add do
      SMODS.add_card{set = 'Base', area = G.deck, enhancement = 'm_shon_alien'}
    end
  end,
  in_pool = function(self)
    return next(SMODS.find_card("j_shon_ouga"))
  end,
  set_card_type_badge = function(self, card, badges)
    badges[#badges + 1] = create_badge(localize('k_shon_event'),
        get_type_colour(card.config.center or card.config, card), G.C.WHITE,
        1.2)
  end
}