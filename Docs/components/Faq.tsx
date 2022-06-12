const Faq = () => (
  <article className="prose prose-invert max-w-none">
    <h2>FAQs</h2>

    <ol>
      <li>
        <b>Will I get banned from the game?</b>
        <br />
        No, I seriously do not think simply reading from an API (outside the
        game) constitutes as cheating.
      </li>

      <li>
        <b>I don&apos;t see a window? Where is the APP?</b>
        <br />
        It is a <b>menu bar</b> APP, check for resin icons that should appear in
        your menu bar.
      </li>

      <li>
        <b>
          Can I configure the refresh rate / data fetching frequency / polling
          interval?
        </b>
        <br />
        Yes - under <code>Preferences</code>.
      </li>

      <li>
        <b>Can I revert back to the original colored resin icon?</b>
        <br />
        Yes - use either one, configured under <code>Preferences</code>.
      </li>

      <li>
        <b>It is not working! Why?</b>
        <br />
        Most often it is your cookie problem. You need to make sure that you
        have turned on <code>Real-Time Notes</code> under{' '}
        <code>Battle Chronicle</code> inside{' '}
        <a
          href="https://www.hoyolab.com/article/1265396"
          target="_blank"
          rel="noopener noreferrer"
        >
          HoYoLAB
        </a>{' '}
        or <code>实时便签</code> inside 米游社, depending on your server. You
        would also have to set your profile to public (instructions for{' '}
        <a
          href="https://www.hoyolab.com/article/117720"
          target="_blank"
          rel="noopener noreferrer"
        >
          HoYoLAB
        </a>{' '}
        (a bit futher down the page) /{' '}
        <a
          href="https://www.9game.cn/yuanshen/5606032.html"
          target="_blank"
          rel="noopener noreferrer"
        >
          米游社
        </a>
        ).
      </li>
    </ol>
  </article>
)
export default Faq
