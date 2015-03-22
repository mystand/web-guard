nodemailer = require 'nodemailer'
emails = JSON.parse(fs.readFileSync(path.join(__dirname, '../config', 'emails.json'))).emails

transporter = nodemailer.createTransport
  service: 'Gmail'
  auth: 
    user: 'lxkuznetsov@gmail.com'
    pass: '121500121500'


module.exports = (site) ->
  console.log("mailing")
#  console.log(emails)
#  mailOptions =
#    from: 'noreply@mystand-sites.herokuapp.com',
#    to: emails.join(", ")
#    subject: 'Сайт упал!'
#    text: "Упал сайт #{site.url}"
#
#  console.log("mail to #{site.url}")

