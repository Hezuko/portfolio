const path = require("path");
const nodemailer = require("nodemailer");

const mailUser = process.env.MAIL_USER;
const mailPass = process.env.MAIL_PASS;
const mailTo = process.env.MAIL_TO || mailUser;

// Transporteur créé seulement si les identifiants sont présents (sinon: no-op gracieux).
const transporter = mailUser && mailPass
  ? nodemailer.createTransport({ service: "gmail", auth: { user: mailUser, pass: mailPass } })
  : null;

function isConfigured() {
  return Boolean(transporter && mailTo);
}

function esc(value) {
  return String(value == null ? "" : value).replace(/[&<>"]/g, function (c) {
    return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c];
  });
}

function buildHtml(d) {
  const message = esc(d.texte).replace(/\n/g, "<br>");
  return `<!DOCTYPE html><html><body style="margin:0;background:#f6f4ef;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background:#f6f4ef;padding:24px 0;">
    <tr><td align="center">
      <table width="520" cellpadding="0" cellspacing="0" style="max-width:520px;width:100%;background:#ffffff;border:1px solid #ded8cd;border-radius:14px;overflow:hidden;font-family:-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;">
        <tr><td style="background:#1f6f57;padding:16px 22px;">
          <table cellpadding="0" cellspacing="0"><tr>
            <td style="padding-right:10px;vertical-align:middle;"><img src="cid:portfoliologo" width="30" height="30" alt="Logo" style="display:block;border-radius:7px;"></td>
            <td style="vertical-align:middle;color:#ffffff;font-size:16px;font-weight:600;">Nouveau message depuis ton portfolio</td>
          </tr></table>
        </td></tr>
        <tr><td style="padding:20px 22px;">
          <table width="100%" cellpadding="0" cellspacing="0" style="font-size:14px;color:#171717;">
            <tr><td width="74" style="color:#6b665d;padding:4px 0;">De</td><td style="padding:4px 0;">${esc(d.prenom)} ${esc(d.nom)}</td></tr>
            <tr><td style="color:#6b665d;padding:4px 0;">Email</td><td style="padding:4px 0;"><a href="mailto:${esc(d.email)}" style="color:#245c4f;text-decoration:none;">${esc(d.email)}</a></td></tr>
            <tr><td style="color:#6b665d;padding:4px 0;">Objet</td><td style="padding:4px 0;">${esc(d.objet)}</td></tr>
          </table>
          <div style="background:#ebe7df;border-radius:8px;padding:14px 16px;margin-top:14px;font-size:14px;line-height:1.6;color:#171717;">${message}</div>
          <a href="mailto:${esc(d.email)}?subject=RE:%20${encodeURIComponent(d.objet)}" style="display:inline-block;margin-top:18px;background:#1f6f57;color:#ffffff;text-decoration:none;font-size:14px;font-weight:600;padding:11px 20px;border-radius:8px;">Répondre à ${esc(d.prenom)}</a>
        </td></tr>
        <tr><td style="border-top:1px solid #ded8cd;padding:12px 22px;font-size:12px;color:#9a958b;">Reçu via le formulaire de contact de ton portfolio.</td></tr>
      </table>
    </td></tr>
  </table></body></html>`;
}

function buildText(d) {
  return `Nouveau message depuis ton portfolio\n\n` +
    `De : ${d.prenom} ${d.nom}\nEmail : ${d.email}\nObjet : ${d.objet}\n\n` +
    `Message :\n${d.texte}\n\n— Reçu via le formulaire de contact. Réponds directement à ${d.email}.`;
}

async function sendContactEmail(d) {
  if (!isConfigured()) return { sent: false, reason: "mail-non-configure" };
  await transporter.sendMail({
    from: `"Portfolio — contact" <${mailUser}>`,
    to: mailTo,
    replyTo: d.email,
    subject: `Nouveau message : ${d.objet}`,
    text: buildText(d),
    html: buildHtml(d),
    attachments: [{
      filename: "logo.png",
      path: path.join(__dirname, "..", "public", "images", "came.png"),
      cid: "portfoliologo",
    }],
  });
  return { sent: true };
}

module.exports = { sendContactEmail, isConfigured };
