require 'faye'

bayeux = Faye::RackAdapter.new(
  :mount   => '/faye',
  :timeout => 20
)
bayeux.listen 9292