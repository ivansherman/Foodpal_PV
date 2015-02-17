Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'Pz5p959yQR7lxgZpr2EVcQ', 'SynbTGU5TXwTlHhwIzbPAljWqN12Twh2nx8J0nbs'
  provider :google_oauth2, '79653098905-dqe50a48n2pkjadamaocrf3besj06f7b.apps.googleusercontent.com', '2ZxTQGEXgt8sTrsWsp0AzfD4'
  provider :facebook, '1450185311867106', '440710523f9b20340615349585ea4684'
  provider :github, 'e402c8490ab7718fe519', 'fb6a3ed30ad3460c39ed192ef7b068b6e980672f', scope: "user"
  provider :linkedin, "777eir8298fxbd", "tNgzcDgv4LEJ9ofB"
  provider :identity
end