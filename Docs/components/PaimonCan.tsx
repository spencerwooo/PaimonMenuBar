import Image from 'next/image'
import paimonMighty from '../images/paimon-mighty.png'

const PaimonCan = () => (
  <div>
    <Image
      className="float-right"
      src={paimonMighty}
      alt="paimon emoji"
      width={128}
      height={128}
      layout="raw"
    />

    <section className="prose prose-invert">
      <h2>Mighty Paimon!</h2>

      <p>Paimon can help you —</p>

      <ul>
        <li>Keep track of your daily resin.</li>
        <li>Monitor your daily expeditions and real-time realm currency.</li>
        <li>Remind you about your daily commissions and weekly boss fights.</li>
        <li>
          And notify you when your parametric transformer is ready to use.
        </li>
      </ul>

      <p>
        Basically, Paimon lives in your macOS menu bar quietly, and offers you a
        nice way of monitoring your in-game real-time stats when you need to
        check them.
      </p>
    </section>
  </div>
)

export default PaimonCan
